defmodule HandlerTest do
  use ExUnit.Case
  import Servy.Handler, only: [handle: 1]
  


  # request = """
  # GET /book/1 HTTP/1.1
  # Host: example.com
  # User-Agent:
  # Accept: */*
  # """

  # response = Servy.Handler.handle(request)
  # IO.puts response

  # request2 = """
  # GET /bears/1 HTTP/1.1
  # Host: example.com
  # User-Agent: Macintash/chrome
  # Accept: */*
  # Content-Type: application/x-www-form-urlencoded

  # name=hello&type=black
  # """
  # response2 = Servy.Handler.handle(request2)
  # IO.puts response2

  # request3 = """
  # GET /about HTTP/1.1
  # Host: example.com
  # User-Agent:
  # Accept: */*
  # """
  # response3 = Servy.Handler.handle(request3)
  # IO.puts response3

  # IO.puts "response4"

  
end
