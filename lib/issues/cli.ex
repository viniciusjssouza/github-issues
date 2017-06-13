defmodule Issues.CLI do

  @moduledoc """
  Handle the command line parsing, returning the command provided by the user
"""

  # the default number of issues to be displayed
  @default_count 4 # -> module constant


  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
    @param argv the argument provided in the command line. It can be `-h` for help,
    or a tuple of {github user name, project, number of issues}

    Return a tuple of `{user, project, count}` or `:help`

    ##Example:
        iex> Issues.CLI.parse_args(["-h"])
        :help

        iex> Issues.CLI.parse_args(["vinicius", "issues", "10"])
        {"vinicius", "issues", 10}

  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parse do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} -> {user, project, String.to_integer(count)}
      {_, [user, project], _} -> {user, project, @default_count}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [count | #{@default_count}]
"""
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_into_ascending_order
    |> Enum.take(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    message = error["message"]
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  defp sort_into_ascending_order(issues) do
    Enum.sort issues, fn a, b -> Map.get(a, "created_at") <= Map.get(b, "created_at") end
  end

  def print_table_for_columns(columns) do

  end

end