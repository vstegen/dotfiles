import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { realpath } from "node:fs/promises";
import { basename, resolve } from "node:path";

const SENSITIVE_DIRECTORIES = new Set([
  ".aws",
  ".azure",
  ".docker",
  ".gnupg",
  ".kube",
  ".ssh",
  "credentials",
  "secrets",
]);

const SENSITIVE_FILE =
  /^(?:\.(?:env(?:\..+)?|netrc|npmrc|pypirc|pgpass|my\.cnf|dockercfg|terraformrc|vault-token)|(?:secrets?|credentials?|passwords?|passwds?|tokens?|api[-_]?keys?|private[-_]?keys?)(?:\..*)?|.+\.(?:key|pem|p12|pfx))$/i;
const SENSITIVE_PATH_IN_COMMAND =
  /(?:^|[\s"'`=:(/])(?:~\/)?(?:[\w.-]+\/)*(?:\.(?:env(?:\.[\w.-]+)?|netrc|npmrc|pypirc|pgpass|my\.cnf|dockercfg|terraformrc|vault-token)|\.(?:aws|azure|docker|gnupg|kube|ssh)(?:\/|$)|(?:secrets?|credentials?|passwords?|passwds?|tokens?|api[-_]?keys?|private[-_]?keys?)(?:\.[\w.-]+)?|[\w.-]+\.(?:key|pem|p12|pfx))(?=$|[\s"'`/):,;])/i;

type PathInput = { path?: unknown };
type CommandInput = { command?: unknown };

function sensitivePath(path: string): boolean {
  const parts = path.split(/[\\/]+/).filter(Boolean);
  return (
    parts.some((part) => SENSITIVE_DIRECTORIES.has(part.toLowerCase())) ||
    SENSITIVE_FILE.test(basename(path))
  );
}

async function isSensitivePath(path: string, cwd: string): Promise<boolean> {
  const absolutePath = resolve(cwd, path.replace(/^@/, ""));
  if (sensitivePath(absolutePath)) return true;

  try {
    return sensitivePath(await realpath(absolutePath));
  } catch {
    return false;
  }
}

function isSensitiveCommand(command: string): boolean {
  return SENSITIVE_PATH_IN_COMMAND.test(command);
}

export default function noSecrets(pi: ExtensionAPI) {
  pi.on("before_agent_start", (event) => ({
    systemPrompt: `${event.systemPrompt}\n- Never access files that might contain secrets, including .env files, credentials, tokens, private keys, or cloud/SSH configuration. The no-secrets extension blocks direct access.`,
  }));

  pi.on("tool_call", async (event, ctx) => {
    let blocked = false;

    if (
      ["read", "write", "edit", "grep", "find", "ls"].includes(event.toolName)
    ) {
      const path = (event.input as PathInput).path;
      blocked =
        typeof path === "string" && (await isSensitivePath(path, ctx.cwd));
    } else if (event.toolName === "bash") {
      const command = (event.input as CommandInput).command;
      blocked = typeof command === "string" && isSensitiveCommand(command);
    }

    if (!blocked) return;

    const reason =
      "Blocked by no-secrets: the requested operation references a file or directory that may contain secrets.";
    if (ctx.hasUI) {
      const allowed = await ctx.ui.confirm(
        "Sensitive file access",
        `${event.toolName} wants to access a file or directory that may contain secrets. Allow this operation?`,
      );
      if (allowed) return;
      ctx.ui.notify(reason, "warning");
    }
    return { block: true, reason };
  });
}
