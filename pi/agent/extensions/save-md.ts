import { writeFile } from "node:fs/promises";
import { basename, isAbsolute, join } from "node:path";
import type { ExtensionAPI, SessionEntry } from "@earendil-works/pi-coding-agent";

function getLastAssistantText(branch: SessionEntry[]): string | undefined {
	for (let index = branch.length - 1; index >= 0; index--) {
		const entry = branch[index];
		if (entry.type !== "message" || entry.message.role !== "assistant") continue;

		const text = entry.message.content
			.map((block) => (block.type === "text" ? block.text : ""))
			.filter(Boolean)
			.join("\n");
		return text || undefined;
	}
	return undefined;
}

function defaultFilename(): string {
	return `assistant-${new Date().toISOString().replaceAll(":", "-")}.md`;
}

function filenameFromArgs(args: string): string {
	const name = args.trim();
	if (!name) return defaultFilename();

	if (name.includes("\0") || name.includes("/") || name.includes("\\") || isAbsolute(name) || basename(name) !== name) {
		throw new Error("Name must be a filename, not a path");
	}

	const filename = /\.md$/i.test(name) ? name : `${name}.md`;
	if (filename === ".md") throw new Error("Name must contain characters before .md");
	return filename;
}

export default function saveMarkdownExtension(pi: ExtensionAPI) {
	pi.registerCommand("save-md", {
		description: "Save the last assistant response as a new Markdown file (usage: /save-md [name])",
		handler: async (args, ctx) => {
			await ctx.waitForIdle();

			const text = getLastAssistantText(ctx.sessionManager.getBranch());
			if (!text) {
				ctx.ui.notify("No assistant text response found", "warning");
				return;
			}

			let filename: string;
			try {
				filename = filenameFromArgs(args);
			} catch (error) {
				ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
				return;
			}

			const path = join(ctx.cwd, filename);
			try {
				await writeFile(path, text, { encoding: "utf8", flag: "wx" });
				ctx.ui.notify(`Saved ${filename}`, "info");
			} catch (error) {
				if ((error as NodeJS.ErrnoException).code === "EEXIST") {
					ctx.ui.notify(`${filename} already exists; nothing was saved`, "error");
					return;
				}
				ctx.ui.notify(`Could not save ${filename}: ${error instanceof Error ? error.message : String(error)}`, "error");
			}
		},
	});
}
