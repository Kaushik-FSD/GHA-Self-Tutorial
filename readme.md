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

### Q3 - Is push the same as deploy?

No. Completely different things.
Here's the full journey of a Docker image:

```
Your Code
    │
    ▼
mvn clean package          ← builds the JAR (compile step)
    │
    ▼
docker build               ← packages JAR into an image (build step)
    │
    ▼
docker push → GHCR         ← uploads image to registry (publish step)
    │
    ▼
kubectl apply / docker run ← pulls image from registry and RUNS it (deploy step)
   on your actual server
```

### Q4 - The github tags names

```
EVENT:     ${{ github.event_name }}    # push / pull_request / workflow_dispatch
BRANCH:    ${{ github.ref_name }}      # main  (short form, no refs/heads/)
FULL_REF:  ${{ github.ref }}           # refs/heads/main
SHA:       ${{ github.sha }}           # full 40-char commit SHA
RUN_NUM:   ${{ github.run_number }}    # auto-incrementing integer (like BUILD_NUMBER)
RUN_ID:    ${{ github.run_id }}        # unique ID for this specific run
ACTOR:     ${{ github.actor }}         # GitHub username who triggered
REPO:      ${{ github.repository }}    # owner/repo-name
WORKSPACE: ${{ github.workspace }}     # /home/runner/work/repo/repo (checked out code)

# ── runner context ─────────────────────────────────────
RUNNER_OS:   ${{ runner.os }}          # Linux / Windows / macOS
RUNNER_ARCH: ${{ runner.arch }}        # X64 / ARM64
```

### Q5 - Jenkins → GHA variable mapping:

```
Jenkins	                GHA
BUILD_NUMBER	        github.run_number
GIT_BRANCH	            github.ref_name
GIT_COMMIT	            github.sha
JOB_NAME	            github.workflow
WORKSPACE	            github.workspace
currentBuild.result	    job.status (in if: conditions)
BUILD_URL	            construct from github.server_url/github.repository/actions/runs/github.run_id
```