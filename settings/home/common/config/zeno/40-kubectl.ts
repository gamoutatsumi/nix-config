// deno-lint-ignore-file no-import-prefix
import { defineConfig } from "jsr:@yuki-yano/zeno@0.1.0";

export default defineConfig(() => {
  const command = new Deno.Command("kubectl", {
    args: ["api-resources", "--verbs=list", "-o", "name"],
    stdout: "piped",
    stderr: "null",
  });
  const { stdout } = command.outputSync();
  const resources = new TextDecoder().decode(stdout).split("\n");
  return {
    snippets: [],
    completions: resources.map((resource) => {
      return {
        name: `kubernetes ${resource}`,
        patterns: [
          `^kubectl delete ${resource} $`,
          `^kubectl describe ${resource} $`,
          `^kubectl get ${resource} $`,
          ...(resource === "pods"
            ? [
              "^kubectl exec pods $",
              "^kubectl logs pods $",
              "^kubectl port-forward pods $",
            ]
            : []),
          ...(resource === "deployments.apps" ? ["^stern $"] : []),
        ],
        options: {
          "--prompt": `'${
            resource.charAt(0).toUpperCase() + resource.slice(1)
          }> '`,
          "--header-lines": 1,
        },
        callback: "awk '{print $1}'",
        sourceCommand: `kubectl get ${resource}`,
      };
    }),
  };
});
