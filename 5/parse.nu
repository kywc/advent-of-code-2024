cat input | parse "{lt}|{gt}" | to json | tee {save rules.json} | to nuon | save rules.nuon
cat input | lines | reverse | take while {|| str contains ','} | each {|| from csv -n} | to json | tee {save updates.json} | to nuon | save updates.nuon
