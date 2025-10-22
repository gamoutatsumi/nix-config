// deno-lint-ignore-file no-import-prefix
import { defineConfig } from "jsr:@yuki-yano/zeno@0.2.0";

export default defineConfig(() => {
  const command = new Deno.Command("kubectl", {
    args: [
      "api-resources",
      "--verbs=list",
      "-o",
      "name",
      "--request-timeout",
      "100ms",
    ],
    stdout: "piped",
    stderr: "null",
  });
  const { stdout } = command.outputSync();
  const resources = new TextDecoder().decode(stdout).split("\n");
  return {
    snippets: [
      {
        name: "kubectl",
        keyword: "kc",
        snippet: "kubectl {{command}}",
      },
      {
        name: "kubie ctx",
        keyword: "kx",
        snippet: "kubie ctx",
      },
      {
        name: "kubie ns",
        keyword: "kn",
        snippet: "kubie ns",
      },
    ],
    completions: resources.map((resource) => {
      return {
        name: `kubernetes ${resource}`,
        patterns: [
          `^kubectl delete ${resource} $`,
          `^kubectl describe ${resource} $`,
          `^kubectl get ${resource} $`,
          ...(resource === "pods"
            ? [
              `^kubectl exec ${resource} $`,
              `^kubectl logs ${resource} $`,
              `^kubectl port-forward ${resource} $`,
              "^stern pod/$",
            ]
            : []),
          ...(resource === "deployments.apps" ? ["^stern deployment/$"] : []),
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
