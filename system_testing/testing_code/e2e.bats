#!/usr/bin/env bats

setup() {
  cd /bucky-core/system_testing/test_bucky_project
}

@test "[e2e] #01 After executing e2e operate go, results have no failures nor errors" {
  run bucky run -t e2e -d -D pc -c pc_e2e_1
  echo "~~~~$output~~~~"
  [ $(expr "$output" : ".*0 failures, 0 errors,.*") -ne 0 ]
}
