import { spawn } from "node:child_process";
import { mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { basename, join } from "node:path";
import type { ExtensionAPI, SessionEntry } from "@earendil-works/pi-coding-agent";
import { Text } from "@earendil-works/pi-tui";

type EditorResult = { ok: true; content: string } | { ok: false; error: string };

function getEditorCommand(): string | undefined {
	return process.env.VISUAL_EDITOR || process.env.VISUAL || process.env.EDITOR;
}

function firstCommandName(command: string): string {
	const match = command.trim().match(/^(?:"([^"]+)"|'([^']+)'|(\S+))/);
	return basename(match?.[1] ?? match?.[2] ?? match?.[3] ?? "");
}

function addWaitFlagForGuiEditor(command: string): string {
	const commandName = firstCommandName(command);
	const isVsCode =
		commandName === "code" || commandName === "code-insiders" || commandName === "codium" || commandName === "cursor";
	const alreadyWaits = /(?:^|\s)(?:--wait|-w)(?=\s|$)/.test(command);
	return isVsCode && !alreadyWaits ? `${command} --wait` : command;
}

function shellQuote(value: string): string {
	return `'${value.replaceAll("'", `'"'"'`)}'`;
}

function runEditor(command: string, file: string, cwd: string): Promise<number | null> {
	return new Promise((resolve) => {
		const child = spawn(`${addWaitFlagForGuiEditor(command)} ${shellQuote(file)}`, {
			cwd,
			stdio: "inherit",
			shell: true,
		});
		child.once("error", () => resolve(null));
		child.once("close", (code) => resolve(code));
	});
}

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

export default function commentExtension(pi: ExtensionAPI) {
	pi.registerCommand("comment", {
		description: "Quote the last assistant response and edit a comment in an external editor",
		handler: async (_args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("comment requires interactive mode", "error");
				return;
			}

			const editorCommand = getEditorCommand();
			if (!editorCommand) {
				ctx.ui.notify("No editor configured. Set $VISUAL_EDITOR, $VISUAL, or $EDITOR.", "error");
				return;
			}

			await ctx.waitForIdle();
			const assistantText = getLastAssistantText(ctx.sessionManager.getBranch());
			if (!assistantText) {
				ctx.ui.notify("No assistant response found", "error");
				return;
			}

			const tempDir = await mkdtemp(join(tmpdir(), "pi-comment-"));
			const tempFile = join(tempDir, "comment.md");
			const quotedResponse = assistantText.split("\n").map((line) => `> ${line}`).join("\n");

			try {
				await writeFile(tempFile, quotedResponse, "utf8");

				const result = await ctx.ui.custom<EditorResult>((tui, _theme, _keybindings, done) => {
					queueMicrotask(() => {
						void (async () => {
							let editorResult: EditorResult;
							tui.stop();
							try {
								process.stdout.write(`Launching external editor: ${editorCommand}\nPi will resume when the editor exits.\n`);
								const exitCode = await runEditor(editorCommand, tempFile, ctx.cwd);
								if (exitCode === 0) {
									editorResult = { ok: true, content: await readFile(tempFile, "utf8") };
								} else if (exitCode === null) {
									editorResult = { ok: false, error: `Could not launch editor: ${editorCommand}` };
								} else {
									editorResult = { ok: false, error: `Editor exited with status ${exitCode}` };
								}
							} catch (error) {
								editorResult = { ok: false, error: error instanceof Error ? error.message : String(error) };
							} finally {
								tui.start();
								tui.requestRender(true);
							}
							done(editorResult);
						})();
					});

					return new Text("Waiting for external editor...", 1, 1);
				});

				if (result.ok) {
					ctx.ui.setEditorText(result.content.replace(/\n$/, ""));
				} else {
					ctx.ui.notify(result.error, "error");
				}
			} finally {
				await rm(tempDir, { recursive: true, force: true });
			}
		},
	});
}
