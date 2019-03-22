#!/usr/bin/env bash
# download assert.sh
# 
. ./shell.sh
. assert.sh

assert "space_fill 10 right test" "test      "
assert "zero_fill 10 1" "0000000001"
assert "timestamp" "$(date "+%Y-%m-%d %H:%M:%S")"
assert "get_date" "$(date "+%Y-%m-%d")"
assert "usage test" "Usage: $0 test"
assert_raises "usage test" 1
assert "check_for_cli_args 2 fail" "Usage: $0 fail" 
assert "require_user user" " para ejecutar este script, Ud. debe ser uno de estos usuarios (user)."
assert "exit_message TDD" "TDD"
assert_raises "exit_message TDD" 1
assert "trim ' hola '" "hola"
assert "rtrim ' hola '" " hola"
assert "ltrim ' hola '" "hola "
assert "lower LOWER" "lower"
assert "upper upper" "UPPER"
assert "ceil 12.5" "13"
assert "floor 12.5" "12"
assert "file_exist ./assert.sh" "YES"
assert "running $0" "YES"
assert "iam_running test_shell.sh" "NOT"
assert "get_os_name" "Linux"
assert "find_string_in_file trim shell.sh" "YES"
assert "continue_question" " Do you want continue? (y/n)? " "y"
assert_raises "continue_question" 0 "y"
assert_raises "continue_question" 1 "n"
#assert "get_color red" "\033[0;31m"
assert "color_string red hola" "\033[0;31mhola\033[0m"


assert_end
