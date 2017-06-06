defmodule CliTest do

  use ExUnit.Case
  doctest Issues.CLI

  import Issues.CLI, only: [parse_args: 1]

  test "call help with -h and -help" do
    assert parse_args(["-h"]) == :help
    assert parse_args(["-help"]) == :help
    assert parse_args(["-help", "lalalala"]) == :help
  end

  test "call with user and project" do
      assert parse_args(["vinicius", "issues"]) == {"vinicius", "issues", 4}
  end

  test "call with user, project and count" do
      assert parse_args(["vinicius", "issues", "6"]) == {"vinicius", "issues", 6}
  end
  
end