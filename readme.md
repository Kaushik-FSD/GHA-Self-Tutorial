### Q1 — environment: staging vs env: ENVIRONMENT: staging

These are completely different things. Same word, different layer.

1. 
```
jobs:
  deploy:
    environment: staging      # ← GitHub FEATURE (capital E conceptually)
                              #   Points to a named Environment configured in
                              #   Repo → Settings → Environments
                              #   Unlocks: env-scoped secrets, approval gates,
                              #   protection rules, deployment tracking in UI
```

2.
```
env:
    ENVIRONMENT: staging    # ← just a shell variable (lowercase e conceptually)
                            #   No GitHub features attached.
                            #   Same as export ENVIRONMENT=staging in bash.
                            #   Only use: referencing $ENVIRONMENT in run: steps
```

### Q2 — Self-hosted Runners & Jenkins Agents

Jenkins Agent = a worker machine that the Jenkins master sends jobs to. Your Jenkins master doesn't run builds itself — it delegates to agents (also called nodes/slaves in older Jenkins). Each agent can have labels like linux, java21, prod-network.
GHA Self-hosted Runner = exact same concept, different name. You install a small runner process on your own machine. GitHub's servers delegate job execution to it. You assign labels during setup. Job says runs-on: [self-hosted, linux] → GitHub finds a matching runner.