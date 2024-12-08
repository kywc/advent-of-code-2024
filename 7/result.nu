cat input.json | jq -c '.' | from json --objects |
  filter { |obj| swipl -f search.pl -t $"has_solutionl\([($obj.sequence)],($obj.result)\)."
                | complete | $in.exit_code == 0 } | get result | into int | math sum
