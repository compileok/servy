defmodule Servy.PledgeServer do

  @name :pledge_server
  def start do
    IO.puts "Startting the pledge server..."
    # pid = spawn(Servy.PledgeServer, :listen_loop, [[]])
    pid = spawn(__MODULE__, :listen_loop, [[]])

    #Process.register(pid, :pledge_server)
    Process.register(pid, @name)

    pid
  end

  def listen_loop(state) do

    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_server(name, amount)
        most_recent_pledges = Enum.take(state, 2)
        new_state = [ {name, amount} | most_recent_pledges ]
        send sender, {:response, id}
        listen_loop(new_state)
      {sender, :recent_pledges} ->
        send sender, {:response, state}
        listen_loop(state)
      {sender, :total_pledged} ->
        total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
        send sender, {:response, total}
        listen_loop(state)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state)
    end
  end

  def create_pledge(name, amount) do
    send  @name, {self(), :create_pledge, name, amount}
    receive do {:response, status} -> status end
  end

  def recent_pledges() do
    send  @name, {self(), :recent_pledges}
    receive do {:response, pledges} -> pledges end
  end


  def total_pledged() do
    send  @name, {self(), :total_pledged}
    receive do {:response, total} -> total end
  end

  defp send_pledge_to_server(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

end

alias Servy.PledgeServer

pid = PledgeServer.start()

send pid, {:stop, "not found"}

IO.inspect PledgeServer.create_pledge("zhangsan", 10)
IO.inspect PledgeServer.create_pledge("lisi", 30)
IO.inspect PledgeServer.create_pledge("wangwu", 20)
IO.inspect PledgeServer.create_pledge("zhaoliu", 40)

IO.inspect PledgeServer.recent_pledges()

IO.inspect PledgeServer.total_pledged()

IO.inspect Process.info(pid, :messages)
