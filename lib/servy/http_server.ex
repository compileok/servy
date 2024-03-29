# server() ->
#   {ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0},
#                                       {active, false}]),
#   {ok, Sock} = gen_tcp:accept(LSock),
#   {ok, Bin} = do_recv(Sock, []),
#   ok = gen_tcp:close(Sock),
#   ok = gen_tcp:close(LSock),
#   Bin.
defmodule Servy.HttpServer do

  @doc """
  Starts the server on the given `port` of localhost.
  """
  def start(port) when is_integer(port) and port > 1023 do
    # Create a socket to listen for client connections.
    # `listen_socket` is bound to the listening sockets.
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])
    # Socket options
    # `:binary` - open the socket in "binary" mode and deliver data as bianries
    # `packet: :raw` - deliver the entire binary without doing any packet handling
    # `active: false` - receive data when we're ready by calling `:gen_tcp.recv/2`
    # `reuseaddr: true` - allows reuseing the address if the listener crashes
    IO.puts "\n Listening for connection requests on port #{port} ...\n"

    accept_loop(listen_socket)
  end

  @doc """
  Accetps client connections on the  `listen_socket`
  """
  def accept_loop(listen_socket) do
    IO.puts " Waitting to accept a client connection... \n"

    # Suspends (blocks) and wait for a client connection. When a connection
    # is accepted, `client_socket` is bound to a new client socket.
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    IO.puts "Connection accepted!\n"
    # Receive the request and sends a response over the client socket.
    #server(client_socket)
    spawn(fn -> server(client_socket) end)

    # Loop back to wait and accept the next connection.
    accept_loop(listen_socket)
  end

  @doc """
  Receives the request on the `client_socket` and
  sends a response back over the same socket.
  """
  def server(client_socket) do
    IO.puts "#{inspect self()}: working on it!"
    client_socket
    |> read_request
    #|> generate_response
    |> Servy.Handler.handle
    |> write_response(client_socket)
  end

  @doc """
  Receives a request on the `client_socket`.
  """
  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)# all available bytes

    # IO.puts " Received request: \n"
    # IO.puts request
    request
  end

  @doc """
  Returns a generic HTTP response.
  """
  def generate_response(_request) do
    """
    HTTP/1.1 200 OK\r
    Content-Type: text/pliain\r
    Content-Length: 6\r
    \r
    Hello!
    """
  end

  @doc """
  Sends the `response` over the `client_socket`.
  """
  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)
    IO.puts " Send response!"
    IO.puts response

    # Closes the client socket, ending the connection.
    # Does not close the listen socket!
    :gen_tcp.close(client_socket)
  end

  # def server do
  #   {:ok, lsock} = :gen_tcp.listen(5678, [:binary, packet: 0,
  #                                       active: false])
  #   {:ok, sock} = :gen_tcp.accept(lsock)
  #   {:ok, bin} = :gen_tcp.recv(sock, 0)
  #   ok = :gen_tcp.close(sock)
  #   ok = :gen_tcp.close(lsock)
  #   bin
  # end
end
