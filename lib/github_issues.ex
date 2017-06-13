defmodule Issues.GithubIssues do
  @headers [{"User-agent", "Elixir programming"}]
  @github_url Application.get_env(:github_issues, :github_url)

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@headers)
    |> handle_response
  end

  def handle_response({:ok, %{status_code: 200, body: json}}) do
    {:ok, Poison.Parser.parse!(json)}
  end

  def handle_response({_, %{status_code: _, body: json}}) do
    {:error, Poison.Parser.parse!(json)}
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end
end
