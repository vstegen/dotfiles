import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { existsSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { execFileSync } from "node:child_process";

type SearchResult = { title: string; url: string; snippet?: string; publishedDate?: string };
type ProviderResult = { provider: string; results: SearchResult[]; note?: string };

const SearchParams = Type.Object({
	query: Type.String({ description: "Web search query" }),
	limit: Type.Optional(Type.Number({ description: "Maximum results to return, default 8" })),
});

const FetchParams = Type.Object({
	url: Type.String({ description: "URL to fetch" }),
	maxChars: Type.Optional(Type.Number({ description: "Maximum extracted text characters, default 20000" })),
});

type WebSearchConfig = Record<string, string | undefined> & {
	kagiApiKey?: string;
	braveApiKey?: string;
	openaiApiKey?: string;
	exaApiKey?: string;
	openaiModel?: string;
	keychainAccount?: string;
	kagiKeychainService?: string;
	braveKeychainService?: string;
	openaiKeychainService?: string;
	exaKeychainService?: string;
};

let configCache: WebSearchConfig | undefined;

function loadConfig(): WebSearchConfig {
	if (configCache) return configCache;
	configCache = {};
	const paths = [
		join(homedir(), ".pi", "agent", "web-search.json"),
		join(process.cwd(), ".pi", "web-search.json"),
	];
	for (const path of paths) {
		try {
			if (existsSync(path)) Object.assign(configCache, JSON.parse(readFileSync(path, "utf8")));
		} catch (e) {
			console.warn(`[web-search] Failed to read ${path}: ${e instanceof Error ? e.message : String(e)}`);
		}
	}
	return configCache;
}

function camelEnvName(name: string) {
	return name.toLowerCase().replace(/_([a-z])/g, (_m, c) => c.toUpperCase());
}

function readKeychain(service: string) {
	const account = loadConfig().keychainAccount || process.env.USER || "pi";
	try {
		return execFileSync("security", ["find-generic-password", "-a", account, "-s", service, "-w"], { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim();
	} catch {
		return undefined;
	}
}

function keychainServiceFor(name: string) {
	const config = loadConfig();
	if (name.includes("KAGI")) return config.kagiKeychainService || "pi-web-search-kagi";
	if (name.includes("BRAVE")) return config.braveKeychainService || "pi-web-search-brave";
	if (name.includes("OPENAI")) return config.openaiKeychainService || "pi-web-search-openai";
	if (name.includes("EXA")) return config.exaKeychainService || "pi-web-search-exa";
	return undefined;
}

function env(...names: string[]) {
	const config = loadConfig();
	for (const name of names) {
		const v = process.env[name] || config[name] || config[camelEnvName(name)];
		if (v && v.trim()) return v.trim();
		const service = keychainServiceFor(name);
		if (service) {
			const secret = readKeychain(service);
			if (secret) return secret;
		}
	}
	return undefined;
}

async function getJson(url: string, init: RequestInit = {}) {
	const res = await fetch(url, init);
	const text = await res.text();
	if (!res.ok) throw new Error(`${res.status} ${res.statusText}: ${text.slice(0, 300)}`);
	return JSON.parse(text);
}

function isLimitOrAuthError(err: unknown) {
	const msg = String(err instanceof Error ? err.message : err).toLowerCase();
	return /\b(401|403|429|quota|limit|rate|billing|payment|insufficient|unauthorized|forbidden)\b/.test(msg);
}

async function searchKagi(query: string, limit: number): Promise<ProviderResult> {
	const key = env("KAGI_API_KEY", "KAGI_SEARCH_API_KEY");
	if (!key) throw new Error("KAGI_API_KEY not set");
	const json = await getJson(`https://kagi.com/api/v0/search?q=${encodeURIComponent(query)}&limit=${limit}`, {
		headers: { Authorization: `Bot ${key}` },
	});
	const data = Array.isArray(json.data) ? json.data : [];
	return { provider: "kagi", results: data.filter((r: any) => r.url).map((r: any) => ({ title: r.title || r.url, url: r.url, snippet: r.snippet || r.summary })) };
}

async function searchBrave(query: string, limit: number): Promise<ProviderResult> {
	const key = env("BRAVE_API_KEY", "BRAVE_SEARCH_API_KEY");
	if (!key) throw new Error("BRAVE_API_KEY not set");
	const json = await getJson(`https://api.search.brave.com/res/v1/web/search?q=${encodeURIComponent(query)}&count=${limit}`, {
		headers: { "X-Subscription-Token": key, Accept: "application/json" },
	});
	const data = json.web?.results || [];
	return { provider: "brave", results: data.map((r: any) => ({ title: r.title || r.url, url: r.url, snippet: r.description, publishedDate: r.age })) };
}

async function searchOpenAI(query: string, limit: number): Promise<ProviderResult> {
	const key = env("OPENAI_API_KEY");
	if (!key) throw new Error("OPENAI_API_KEY not set; pi subscription OAuth is not exposed to extensions");
	const json = await getJson("https://api.openai.com/v1/responses", {
		method: "POST",
		headers: { Authorization: `Bearer ${key}`, "Content-Type": "application/json" },
		body: JSON.stringify({
			model: env("PI_WEB_OPENAI_MODEL", "OPENAI_MODEL") || "gpt-4.1-mini",
			tools: [{ type: "web_search_preview" }],
			input: `Search the web for: ${query}\nReturn up to ${limit} results as JSON array with title, url, snippet.`,
		}),
	});
	const text = json.output_text || JSON.stringify(json.output || []);
	const urls = [...text.matchAll(/https?:\/\/[^\s)\]"']+/g)].slice(0, limit).map((m, i) => ({ title: `OpenAI web result ${i + 1}`, url: m[0], snippet: text.slice(0, 1000) }));
	return { provider: "openai", results: urls.length ? urls : [{ title: "OpenAI web search response", url: "", snippet: text }] };
}

async function searchExa(query: string, limit: number): Promise<ProviderResult> {
	const key = env("EXA_API_KEY");
	if (!key) throw new Error("EXA_API_KEY not set");
	const json = await getJson("https://api.exa.ai/search", {
		method: "POST",
		headers: { "x-api-key": key, "Content-Type": "application/json" },
		body: JSON.stringify({ query, numResults: limit, contents: { text: { maxCharacters: 500 } } }),
	});
	return { provider: "exa", results: (json.results || []).map((r: any) => ({ title: r.title || r.url, url: r.url, snippet: r.text || r.summary, publishedDate: r.publishedDate })) };
}

function format(result: ProviderResult, attempts?: string[]) {
	const lines = [`Provider: ${result.provider}`, ""];
	for (const [i, r] of result.results.entries()) lines.push(`${i + 1}. ${r.title}\n   ${r.url}${r.snippet ? `\n   ${r.snippet}` : ""}`);
	if (attempts?.length) lines.push("", "Fallback notes:", ...attempts.map(a => `- ${a}`));
	return lines.join("\n");
}

export default function webSearch(pi: ExtensionAPI) {
	pi.registerTool({
		name: "web_search",
		label: "Web Search",
		description: "Search the web. Provider order: Kagi, Brave, OpenAI web search, Exa.",
		promptSnippet: "Search the web for current information using Kagi, then Brave, then OpenAI, then Exa fallback.",
		promptGuidelines: ["Use web_search when current external information, documentation, news, or website discovery is needed. Prefer web_search over guessing."],
		parameters: SearchParams,
		async execute(_id, params) {
			const limit = Math.max(1, Math.min(20, Math.floor(params.limit || 8)));
			const attempts: string[] = [];
			for (const fn of [searchKagi, searchBrave, searchOpenAI, searchExa]) {
				try {
					const result = await fn(params.query, limit);
					if (result.results.length) return { content: [{ type: "text", text: format(result, attempts) }], details: result };
					attempts.push(`${result.provider}: no results`);
				} catch (e) {
					attempts.push(`${fn.name.replace("search", "").toLowerCase()}: ${e instanceof Error ? e.message : String(e)}`);
					if (!isLimitOrAuthError(e)) continue;
				}
			}
			return { content: [{ type: "text", text: `All web search providers failed.\n${attempts.join("\n")}` }], details: { attempts } };
		},
	});

	pi.registerTool({
		name: "fetch_url",
		label: "Fetch URL",
		description: "Fetch a URL and return readable text/HTML excerpt.",
		promptSnippet: "Fetch and read a webpage by URL.",
		parameters: FetchParams,
		async execute(_id, params) {
			const max = Math.max(1000, Math.min(100000, Math.floor(params.maxChars || 20000)));
			const res = await fetch(params.url, { headers: { "User-Agent": "pi-web-search/1.0" } });
			const raw = await res.text();
			if (!res.ok) throw new Error(`${res.status} ${res.statusText}: ${raw.slice(0, 300)}`);
			const text = raw.replace(/<script[\s\S]*?<\/script>/gi, " ").replace(/<style[\s\S]*?<\/style>/gi, " ").replace(/<[^>]+>/g, " ").replace(/&nbsp;/g, " ").replace(/&amp;/g, "&").replace(/\s+/g, " ").trim().slice(0, max);
			return { content: [{ type: "text", text }], details: { url: params.url, status: res.status, chars: text.length } };
		},
	});
}
