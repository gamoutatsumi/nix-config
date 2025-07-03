package zeno

#contexts: {
	commit: lbuffer:   "git\\scommit\\s+"
	git: lbuffer:      "git\\s+"
	diff: lbuffer:     "git\\sdiff\\s+"
	checkout: lbuffer: "git\\scheckout\\s+"
	workflow: lbuffer: "gh\\sworkflow\\s.*"
	any: lbuffer:      ".+\\s+"
}
snippets: [{
	name:    "kubectl"
	keyword: "kc"
	snippet: "kubectl {{command}}"
}, {
	name:    "kubie ctx"
	keyword: "kx"
	snippet: "kubie ctx"
}, {
	name:    "kubie ns"
	keyword: "kn"
	snippet: "kubie ns"
}, {
	name:    "docker compose"
	keyword: "dc"
	snippet: "docker compose"
}, {
	name:    "pipe to vim"
	keyword: "V"
	snippet: "| vim -"
	context: #contexts.any
}, {
	name:    "git status short branch"
	keyword: "gs"
	snippet: "git status --short --branch"
}, {
	name:    "git clean fdx"
	keyword: "call"
	snippet: "clean -fdx"
	context: #contexts.git
}, {
	name:    "git add"
	keyword: "ga"
	snippet: "git add {{file}}"
}, {
	name:    "git add all"
	keyword: "gaa"
	snippet: "git add --all"
}, {
	name:    "git commit"
	keyword: "gci"
	snippet: "git commit"
}, {
	name:    "git commit message"
	keyword: "gcim"
	snippet: "git commit -m '{{commit_message}}'"
}, {
	name:    "git commit fixup"
	keyword: "f"
	snippet: "--fixup {{commit_id}}"
	context: #contexts.commit
}, {
	name:    "git commit amend"
	keyword: "a"
	snippet: "--amend"
	context: #contexts.commit
}, {
	name:    "git commit amend noedit"
	keyword: "an"
	snippet: "--amend --no-edit"
	context: #contexts.commit
}, {
	name:    "git empty commit"
	keyword: "init"
	snippet: "--allow-empty -m 'Initial Commit'"
	context: #contexts.commit
}, {
	name:    "git diff"
	keyword: "gd"
	snippet: "git diff {{branch}}"
}, {
	name:    "git diff file"
	keyword: "f"
	snippet: "git diff -- {{file}}"
	context: #contexts.diff
}, {
	name:    "git diff branch file"
	keyword: "bf"
	snippet: "{{branch}} -- {{file}}"
	context: #contexts.diff
}, {
	name:    "git diff 2 branch"
	keyword: "bb"
	snippet: "{{branch1}} {{brahcn2}}"
	context: #contexts.diff
}, {
	name:    "git diff 2 branch file"
	keyword: "bbf"
	snippet: "{{branch1}} {{brahcn2}} -- {{file}}"
	context: #contexts.diff
}, {
	name:    "git diff cached"
	keyword: "c"
	snippet: "--cached"
	context: #contexts.diff
}, {
	name:    "git diff cached file"
	keyword: "cf"
	snippet: "--cached -- {{file}}"
	context: #contexts.diff
}, {
	name:    "git checkout"
	keyword: "gco"
	snippet: "git checkout {{branch}}"
}, {
	name:    "git checkout file"
	keyword: "f"
	snippet: "-- {{file}}"
	context: #contexts.checkout
}, {
	name:    "git checkout branch file"
	keyword: "bf"
	snippet: "{{branch}} -- {{file}}"
	context: #contexts.checkout
}, {
	name:    "git checkout track"
	keyword: "t"
	snippet: "--track {{origin_branch}}"
	context: #contexts.checkout
}, {
	name:    "git rebase squash"
	keyword: "squash"
	snippet: "rebase --interactive --autosquash {{branch}}"
	context: #contexts.git
}, {
	name:    "git main branch"
	keyword: "main_branch"
	snippet: "basename \"$(git symbolic-ref --short refs/remotes/origin/HEAD)\""
}, {
	name:    "git new branch with date suffix"
	keyword: "gnb"
	snippet: "git switch -c \"{{branch}}_$(date +%Y%m%d)\""
}, {
	name:    "tms"
	keyword: "t"
	snippet: "tms"
}, {
	name:    "tmux swap pane"
	keyword: "ts"
	snippet: "tmux swap-pane -t"
}, {
	name:    "null"
	keyword: "null"
	snippet: "> /dev/null 2>&1"
	context: #contexts.any
}, {
	name:    "stdout to null"
	keyword: "null1"
	snippet: "> /dev/null"
	context: #contexts.any
}, {
	name:    "stderr to null"
	keyword: "null2"
	snippet: "2> /dev/null"
	context: #contexts.any
}, {
	name:    "pipe grep"
	keyword: "G"
	snippet: "| rg '{{pattern}}'"
	context: #contexts.any
}, {
	name:    "pipe head"
	keyword: "H"
	snippet: "| head -n "
	context: #contexts.any
}, {
	name:    "copy stdout"
	keyword: "C"
	snippet: "| pbcopy"
	context: #contexts.any
}, {
	name:    "pipe less"
	keyword: "L"
	snippet: "| less"
	context: #contexts.any
}, {
	name:    "pipe jq"
	keyword: "J"
	snippet: "| jq .{{query}}"
	context: #contexts.any
}, {
	name:    "pipe gron"
	keyword: "JG"
	snippet: " | gron | grep"
	context: #contexts.any
}, {
	name:    "ungron"
	keyword: "UG"
	snippet: " | gron -u"
	context: #contexts.any
}, {
	name:     "branch"
	keyword:  "B"
	snippet:  "git symbolic-ref --short HEAD"
	context:  #contexts.checkout
	evaluate: true
}, {
	name:    "git switch"
	keyword: "gsw"
	snippet: "git switch {{branch}}"
}, {
	name:    "git switch create"
	keyword: "gswc"
	snippet: "git switch -c {{branch}}"
}]
completions: [{
	name: "kill"
	patterns: ["^kill( -9)? $"]
	sourceCommand: "ps -ef | sed 1d"
	options: {
		"--multi":  true
		"--prompt": "'Kill Process> '"
	}
	callback: "awk '{print $2}'"
}, {
	name: "ssh"
	patterns: ["^ssh $"]
	sourceCommand: "grep '^Host' ~/.ssh/config | awk '{print $2}'"
	options: "--prompt": "'Connect to> '"
	callback: "awk '{print $1}'"
}, {
	name: "cd"
	patterns: ["^cd $"]
	sourceCommand: "fd --type=d"
	options: {
		"--prompt":         "'To> '"
		"--preview-window": "right:50%"
		"--preview":        "lsd -l"
	}
	callback: "awk '{print $1}'"
}, {
	name: "workflows"
	patterns: ["^gh workflow.* $"]
	sourceCommand: "gh workflow list"
	callback:      "awk '{print $NF}'"
	options: {
		"--prompt":         "'Workflow> '"
		"--preview-window": "right:50%"
		"--preview":        "gh workflow view {1}"
	}
}, {
	name: "Makefile"
	patterns: ["^make $"]
	sourceCommand: "make help | sed -E \"s/\\x1b\\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[mGK]//g\""
	callback:      "awk '{printf $1}'"
	options: "--prompt": "'Target> '"
}, {
	name: "GitHub PRs"
	patterns: [
		"^gh co $",
		"^gh prv $",
	]
	sourceCommand: "gh pr list"
	options: {
		"--prompt":         "'Pull Request> '"
		"--preview-window": "right:50%"
		"--preview":        "gh pr view {1}"
	}
	callback: "awk '{print $1}'"
}, {
	name: "GitHub Issues"
	patterns: ["^gh iv $"]
	sourceCommand: "gh issue list"
	options: {
		"--prompt":         "'Issue> '"
		"--preview-window": "right:50%"
		"--preview":        "gh issue view {1}"
	}
	callback: "awk '{print $1}'"
}, {
	name: "docker images"
	patterns: ["^docker rmi $"]
	options: {
		"--prompt":         "'Image> '"
		"--preview-window": "right:50%"
		"--preview":        "docker image inspect {1}"
		"--multi":          true
	}
	callback:      "awk '{print $3}'"
	sourceCommand: "docker images | sed 1d"
}, {
	name: "docker containers (all)"
	patterns: ["^docker rm $"]
	options: {
		"--prompt":         "'Container> '"
		"--preview-window": "right:50%"
		"--preview":        "docker container inspect {1}"
		"--multi":          true
	}
	callback:      "awk '{print $1}'"
	sourceCommand: "docker ps --filter status=exited | sed 1d"
}, {
	name: "docker containers (running)"
	patterns: ["^docker stop $"]
	options: {
		"--prompt":         "'Container> '"
		"--preview-window": "right:50%"
		"--preview":        "docker container inspect {1}"
		"--multi":          true
	}
	callback:      "awk '{print $1}'"
	sourceCommand: "docker ps | sed 1d"
}, {
	name: "kubernetes pods"
	patterns: ["^kubectl delete pods $", "^kubectl exec pods $", "^kubectl logs pods $", "^kubectl port-forward pods $", "^kubectl describe pods $", "^kubectl get pods $"]
	options: {
		"--prompt": "'Pod> '"
		"--multi":  false
	}
	callback:      "awk '{print $1}'"
	sourceCommand: "kubectl get pods --no-headers"
}, {
	name: "kubernetes deployments"
	patterns: ["^kubectl delete deployments $", "^kubectl describe deployments $", "^kubectl get deployments $", "^stern $"]
	options: {
		"--prompt": "'Deployment> '"
		"--multi":  false
	}
	callback:      "awk '{print $1}'"
	sourceCommand: "kubectl get deployments --no-headers"
}]
