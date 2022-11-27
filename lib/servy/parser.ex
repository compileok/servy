defmodule Servy.Parser do

  alias Servy.Conv
  def parse(request) do
    IO.puts "==== parser ===="
    # first_line = request |> String.split("\n") |> List.first
    # [method, path, version] = String.split(first_line," ")
    # %{ method: method, path: path, resp_body: ""}

    # [method, path, _] =
    #   request
    #   |> String.split("\n")
    #   |> List.first
    #   |> String.split(" ")

    [top, params_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines, %{})

    params = parse_params(params_string)

    IO.inspect header_lines

    %Conv{
       method: method,
       path: path,
       params: params,
       headers: headers
    }

  end


  def parse_headers([head | tail], headers ) do
    [key, value] = String.split(head, ": ")

    new_eaders = Map.put(headers, key, value)

    IO.inspect new_eaders

    parse_headers(tail, new_eaders)
  end

  def parse_headers([], headers) do
    IO.puts " It's done! "
    headers
  end

  def parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end

end
