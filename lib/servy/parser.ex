defmodule Servy.Parser do

  alias Servy.Conv
  def parse(request) do

    IO.puts "=== parse request... "
    IO.puts request
    IO.puts "===================="

    String.split(request, "\n\n") |> IO.puts

    [top, params_string] = String.split(request, "\r\n\r\n")
    IO.puts "==================== parse top "<> top

    IO.puts "===================="

    IO.puts "==================== parse params_string "<> params_string

    IO.puts "==================== "

    [request_line | header_lines] = String.split(top, "\r\n")

    IO.puts "==================== request_line" <> request_line


    [method, path, _] = String.split(request_line, " ")
    IO.puts "==================== method" <> method
    IO.puts "==================== path" <> path

    headers = parse_headers(header_lines)

    params = parse_params(headers["Content-Type"], params_string)

    IO.inspect header_lines
    IO.puts "==== parser end ===="

    %Conv{
       method: method,
       path: path,
       params: params,
       headers: headers
    }

  end


  # def parse_headers([head | tail], headers ) do
  #   [key, value] = String.split(head, ": ")
  #   new_eaders = Map.put(headers, key, value)
  #   parse_headers(tail, new_eaders)
  # end

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn line, headers_map ->
      [key, value] = String.split(line, ": ")
      Map.put(headers_map, key, value)
    end)
  end

  def parse_headers([], headers) do
    headers
  end

  @doc """
    pass param like xxx
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}


end
