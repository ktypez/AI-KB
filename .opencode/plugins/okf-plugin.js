export const OkfPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool === "read" && output.args.filePath) {
        const filePath = output.args.filePath;
        if (filePath.endsWith(".md") && filePath.includes("AI-KB")) {
          output.args.parseFrontmatter = true;
        }
      }
    },
  };
};
