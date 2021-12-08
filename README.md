# trigger-action-workflow
Trigger GitHub action workflow file from another repo and wait to it will be done.

## Example usage

Here is an example setup of this action:

1. Create a `.github/workflows/ci-initiator.yml` file in your GitHub repo.
2. Add the following code to the file.

```yml
name: CI-Initiator

on:
  push:

jobs:
  startCI:
    runs-on: ubuntu-latest
    steps:
      - name: Get Short SHA
        id: vars
        run: |
          echo ::set-output name=sha_short::${GITHUB_SHA::7}

      - name: Trigger Remote Action
        uses: AndyKIron/trigger-action-workflow@main
        with:
          owner: REMOTE_REPO_OWNER # remote repository owner
          repo: REMOTE_REPO_NAME #remote repository name
          github_token: ${{ secrets.PAT_TOKEN }} # your token
          workflow_file_name: ci.yml # remote action workflow file name
          job_name_substring: "::${{github.ref_name}}:${{ steps.vars.outputs.sha_short }}"
          inputs: '{ "branch_name": "${{github.ref_name}}", "user": "${{github.actor}}", "sha": "${{ steps.vars.outputs.sha_short }}"}'

      - name: Done
        run: |
          echo "Workflow Done"
```

### Inputs (with)

| Variable           |          | Purpose                                                           |
|--------------------|----------|-------------------------------------------------------------------|
| owner              | required | Remote repository owner name                                      |
| repo               | required | Remote repository name                                            |
| github_token       | required | Generated Personal Access Token                                   |
| workflow_file_name | required | Remote action workflow filename (with .extension)                 |
| job_name_substring | required | Some unique string to identify the running remote action workflow |
| inputs             | required | JSON for remote action inputs                                     |


3. On remote target action workflow file (ci.yml for example) you need add needed inputs
4. And one (first) stem must have "name:" with "job_name_substring"

```yml
name: CI-Starter

on:
  workflow_dispatch:
    inputs:
      branch_name:
        required: true
      user:
        required: true
      sha:
        required: true

jobs:
  # --- Do Job Initiator for ci_initiator can find it in from API
  ci-init:
    name: 'CI-Init::${{ github.event.inputs.branch_name }}:${{ github.event.inputs.sha }}'
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo "Start CI for ${{ github.event.inputs.user }}:${{ github.event.inputs.branch_name }}:${{ github.event.inputs.sha }}"
  ...
  ...
  ...
```



