  i=0
  while [  $i -le 5 ]
  do
    echo Number: $i
    let "i++"
    sleep 1
  done
  echo "Done: ${i}"
