  i=0
  try_count=0
  try_max=10

  while [  $i -le 15 ]
  do
    echo Number: $i
    let "i++"

    status="queued"
    if [[ try_count -ge try_max ]]
    then
      # if was try limit, do check with status - in_progress
      status="in_progress"
    fi
    query="event=workflow_dispatch&status=${status}"

    echo ">>$query"

    let "try_count++"
    sleep 1
  done
  echo "Done: ${i}"
