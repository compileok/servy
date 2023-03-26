defmodule Servy.Handler do
  @moduledoc """
    Handle something
  """

  @about_page_path Path.expand("../../pages/",__DIR__)

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  alias Servy.VideoCam
  alias Servy.Conv
  alias Servy.BearController
  alias Servy.Api.BearController, as: ApiBearController
  # alias Servy.Fetcher

  @doc "desc about the function"
  def handle(request) do
    # conv = parse(request)
    # conv = route(conv)
    # format_response(conv)
    request
    |> parse
    |> log
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end


  # def route(%Conv{} = conv) do
  #   # conv = %{ method: "GET", path: "/sompath", resp_body: "Hello ,this is body content."}

  #   # %{conv | resp_body: "Hello, this is the content."}
  #   route(conv, conv.method, conv.path)
  # end

  def route(%Conv{ method: "GET", path: "/about"} = conv) do
    @about_page_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end
  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end
  def handle_file({:error, enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found."}
  end
  def handle_file({:error, message}, conv) do
    %{conv | status: 500, resp_body: "File error:#{message}"}
  end
  # def route(conv, "GET", "/about") do
  #   file = Path.expand("../../pages/",__DIR__) |> Path.join("about.html")
  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{conv | status: 200, resp_body: content}
  #     {:error, enoent} ->
  #         %{conv | status: 404, resp_body: "File not found."}
  #     {:error, message} ->
  #       %{conv | status: 500, resp_body: "File error:#{message}"}
  #   end
  # end

  def route(%Conv{ method: "GET", path: "/hello"} = conv) do
    %{conv | status: 200, resp_body: "Wellcome to Elixir world."}
  end

  def route(%Conv{ method: "GET", path: "/sensors"} = conv) do

    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    where_is_bigfoot = Task.await(task)

    snapshots  =
    ["cam-1", "cam-2", "cam-3"]
    |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
    |> Enum.map(&Task.await/1)
    # snapshots  =
    # ["cam-1", "cam-2", "cam-3"]
    # |> Enum.map(&Fetcher.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
    # |> Enum.map(&Fetcher.get_result/1)

    # pid4 = Fetcher.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    # where_is_bigfoot = Fetcher.get_result(pid4)

    %{conv | status: 200, resp_body: inspect {snapshots, where_is_bigfoot}}
  end


  def route(%Conv{ method: "POST", path: "/pledges"} = conv) do
#
  end

  def route(%Conv{ method: "GET", path: "/pledges"} = conv) do

  end

  def route(%Conv{ method: "GET", path: "/hibiernate/"<>time} = conv) do
    time |> String.to_integer |> :timer.sleep
    %{conv | status: 200, resp_body: "Awake!"}
  end
  def route(%Conv{ method: "GET", path: "/book"} = conv) do

    %{conv | status: 200, resp_body: "Elixir In Action, Elixir CookBook"}
  end


  def route(%Conv{ method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/api/bears"} = conv) do
    ApiBearController.index(conv)
  end

  def route(%Conv{ method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{ method: "GET", path: "/bears/" <> id} = conv) do
    IO.puts " ##### route to /bears/" <> id

    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{ path: path } = conv) do
    %{conv | status: 404, resp_body: "#{conv.path} is not found."}
  end



  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: #{conv.resp_content_type}
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  # private function inside module
  # defp status_reason(code) do
  #   %{
  #     200 => "OK",
  #     201 => "Created",
  #     401 => "Unauthorized",
  #     403 => "Forbidden",
  #     404 => "Not Found",
  #     500 => "Internal Server Error"
  #   }[code]
  # end


  def test() do
    IO.puts "====== test is running ======"
    request2 = """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: Macintash/chrome
    Accept: */*
    Content-Type: application/x-www-form-urlencoded


    name=hello&type=black1
    """
    response2 = Servy.Handler.handle(request2)
    IO.puts response2
  end

  def test2() do
    IO.puts "====== test is running ======"
    request2 = """
    GET /bears/1 HTTP/1.1
    Host: example.com
    User-Agent: Macintash/chrome
    Accept: */*
    Content-Type: application/x-www-form-urlencoded


    name=hello&type=black1
    """
    response2 = Servy.Handler.handle(request2)
    IO.puts response2
  end
end
