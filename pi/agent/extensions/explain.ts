import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const EXPLANATION_CHECKLIST =
  "feature, abstractions, code path, configuration, types, and data paths work?";

export default function explainExtension(pi: ExtensionAPI) {
  pi.registerCommand("explain", {
    description:
      "Explain a prompt, including how the feature, abstractions, code path, configuration, types, and data paths work",
    handler: async (args, ctx) => {
      const prompt = args.trim();
      if (!prompt) {
        ctx.ui.notify("Usage: /explain <prompt>", "warning");
        return;
      }

      pi.sendUserMessage(
        `How does ${prompt} ${EXPLANATION_CHECKLIST}`,
        ctx.isIdle() ? undefined : { deliverAs: "followUp" },
      );
    },
  });
}
