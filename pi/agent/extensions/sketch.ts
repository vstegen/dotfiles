import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const SKETCH_INSTRUCTIONS =
  "Walk me through the code paths, data structures you would create, update, or change, the types you would add, change, delete, anything relevant like that. We really want to focus on code paths, types, abstractions, and data flow.";

export default function sketchExtension(pi: ExtensionAPI) {
  pi.registerCommand("sketch", {
    description:
      "Analyze a prompt with a focus on code paths, types, abstractions, and data flow",
    handler: async (args, ctx) => {
      const prompt = args.trim();
      if (!prompt) {
        ctx.ui.notify("Usage: /sketch <prompt>", "warning");
        return;
      }

      pi.sendUserMessage(
        `${prompt} ${SKETCH_INSTRUCTIONS}`,
        ctx.isIdle() ? undefined : { deliverAs: "followUp" },
      );
    },
  });
}
