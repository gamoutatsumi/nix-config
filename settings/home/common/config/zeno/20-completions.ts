import { defineConfig } from "jsr:@yuki-yano/zeno@0.1.0";

export default defineConfig(() => {
  return {
    snippets: [],
    completions: [{
      name: "kill",
      patterns: ["^kill( -9)? $"],
      sourceCommand: "ps -ef",
      options: {
        "--multi": true,
        "--prompt": "'Kill Process> '",
        "--header-lines": 1,
      },
      callback: "awk '{print $2}'",
    }, {
      name: "ssh",
      patterns: ["^ssh $"],
      sourceCommand: "grep '^Host' ~/.ssh/config | awk '{print $2}'",
      options: {
        "--prompt": "'Connect to> '",
      },
      callback: "awk '{print $1}'",
    }, {
      name: "cd",
      patterns: ["^cd $"],
      sourceCommand: "fd --type=d",
      options: {
        "--prompt": "'To> '",
        "--preview-window": "right:50%",
        "--preview": "lsd -l",
      },
      callback: "awk '{print $1}'",
    }, {
      name: "workflows",
      patterns: ["^gh workflow.* $"],
      sourceCommand: "gh workflow list",
      callback: "awk '{print $NF}'",
      options: {
        "--prompt": "'Workflow> '",
        "--preview-window": "right:50%",
        "--preview": "gh workflow view {1}",
      },
    }, {
      name: "GitHub PRs",
      patterns: [
        "^gh co $",
        "^gh prv $",
      ],
      sourceCommand: "gh pr list",
      options: {
        "--prompt": "'Pull Request> '",
        "--preview-window": "right:50%",
        "--preview": "gh pr view {1}",
      },
      callback: "awk '{print $1}'",
    }, {
      name: "GitHub Issues",
      patterns: ["^gh iv $"],
      sourceCommand: "gh issue list",
      options: {
        "--prompt": "'Issue> '",
        "--preview-window": "right:50%",
        "--preview": "gh issue view {1}",
      },
      callback: "awk '{print $1}'",
    }, {
      name: "docker images",
      patterns: ["^docker rmi $"],
      options: {
        "--prompt": "'Image> '",
        "--preview-window": "right:50%",
        "--preview": "docker image inspect {1}",
        "--multi": true,
        "--header-lines": 1,
      },
      callback: "awk '{print $3}'",
      sourceCommand: "docker images",
    }, {
      name: "docker containers (all)",
      patterns: ["^docker rm $"],
      options: {
        "--prompt": "'Container> '",
        "--preview-window": "right:50%",
        "--preview": "docker container inspect {1}",
        "--multi": true,
        "--header-lines": 1,
      },
      callback: "awk '{print $1}'",
      sourceCommand: "docker ps --filter status=exited",
    }, {
      name: "docker containers (running)",
      patterns: ["^docker stop $"],
      options: {
        "--prompt": "'Container> '",
        "--preview-window": "right:50%",
        "--preview": "docker container inspect {1}",
        "--multi": true,
        "--header-lines": 1,
      },
      callback: "awk '{print $1}'",
      sourceCommand: "docker ps",
    }, {
      name: "kubernetes pods",
      patterns: [
        "^kubectl delete pods $",
        "^kubectl exec pods $",
        "^kubectl logs pods $",
        "^kubectl port-forward pods $",
        "^kubectl describe pods $",
        "^kubectl get pods $",
      ],
      options: {
        "--prompt": "'Pod> '",
        "--header-lines": 1,
      },
      callback: "awk '{print $1}'",
      sourceCommand: "kubectl get pods",
    }, {
      name: "kubernetes deployments",
      patterns: [
        "^kubectl delete deployments $",
        "^kubectl describe deployments $",
        "^kubectl get deployments $",
        "^stern $",
      ],
      options: {
        "--prompt": "'Deployment> '",
        "--header-lines": 1,
      },
      callback: "awk '{print $1}'",
      sourceCommand: "kubectl get deployments",
    }],
  };
});
