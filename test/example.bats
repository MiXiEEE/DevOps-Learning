#!/usr/bin/env bats

@test "Check if bash-exit-status.sh is executable" {
    [ -x "./bash-scripting/bash-basics/bash-exit-status.sh" ]
}

@test "Check if bash-exit-status.sh runs successfully" {
    run bash ./bash-scripting/bash-basics/bash-exit-status.sh
    [ "$status" -eq 0 ]
}