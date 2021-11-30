#!/bin/sh
set -e


TEST_STRING="Validate Code"

echo "Test 2"

# get needed workflow id
workflow_id="null"
# get list of workflows
list_workflows_ids=$(curl -X GET "https://api.github.com/repos/ironsource-mobile/fusion-actions/actions/workflows/code-validate.yml/runs?event=workflow_dispatch" \
  -H 'Accept: application/vnd.github.antiope-preview+json' \
  -H "Authorization: Bearer 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" | jq '.workflow_runs[] | select(.conclusion=="failure" or .conclusion=="cancelled") | .id')

echo ">> $list_workflows_ids"
# check each for needed job name
for wf_id in $list_workflows_ids
do
	echo  "::: $wf_id :: $TEST_STRING"

	job_id=$(curl -X GET "https://api.github.com/repos/ironsource-mobile/fusion-actions/actions/runs/$wf_id/jobs" \
	  -H 'Accept: application/vnd.github.antiope-preview+json' \
    -H "Authorization: Bearer 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" | jq ".jobs[] | select(.name | test(\"$TEST_STRING\")) | .id")

  echo "== $job_id"

  if  [[ ! -z "$job_id" ]]
  then
    workflow_id=$wf_id
    break
  fi
done
echo ">> $workflow_id"
