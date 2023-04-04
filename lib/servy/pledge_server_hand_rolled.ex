defmodule Server.GenericServer do


  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end


  # helper functions
  def call(pid, message) do
    send  pid, {:call, self(), message}
    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

    # Server
    def listen_loop(state, callback_module ) do
      receive do
        {:call, sender, message} when is_pid(sender) ->
          {response, new_state} = callback_module.handle_call(message, state)
          send sender, {:response, response}
          listen_loop(new_state, callback_module)
        {:cast,  message} ->
          new_state = callback_module.handle_cast(message, state)
          listen_loop(new_state, callback_module)
        # {sender, {:create_pledge, name, amount}}->
        #   {:ok, id} = send_pledge_to_server(name, amount)
        #   most_recent_pledges = Enum.take(state, 2)
        #   new_state = [ {name, amount} | most_recent_pledges ]
        #   send sender, {:response, id}
        #   listen_loop(new_state)
        # {sender, :recent_pledges} ->
        #   send sender, {:response, state}
        #   listen_loop(state)
        # {sender, :total_pledged} ->
        #   total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
        #   send sender, {:response, total}
        #   listen_loop(state)
        unexpected ->
          IO.puts "Unexpected message: #{inspect unexpected}"
          listen_loop(state, callback_module)
      end

    end

end

defmodule Servy.PledgeServerHandRolled do

  alias Server.GenericServer

  @name :pledge_server_hand_rolled

  def start() do
    IO.puts "Startting the pledge server..."
    GenericServer.start(__MODULE__, [], @name)
  end



  def handle_cast(:clear, _state) do
    []
  end

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    { state, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_server(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [ {name, amount} | most_recent_pledges ]
    {id, new_state}
  end

  def create_pledge(name, amount) do
    GenericServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges() do
    GenericServer.call @name, :recent_pledges
  end

  def total_pledged() do
    GenericServer.call @name, :total_pledged
  end

  def clear do
    GenericServer.cast @name, :clear
  end

  defp send_pledge_to_server(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

end

# alias Servy.PledgeServerHandRolled

# pid = PledgeServerHandRolled.start()

# send pid, {:stop, "not found"}

# IO.inspect PledgeServerHandRolled.create_pledge("zhangsan", 10)
# IO.inspect PledgeServerHandRolled.create_pledge("lisi", 30)
# IO.inspect PledgeServerHandRolled.create_pledge("wangwu", 20)
# PledgeServerHandRolled.clear()

# IO.inspect PledgeServerHandRolled.create_pledge("zhaoliu", 40)


# IO.inspect PledgeServerHandRolled.recent_pledges()

# IO.inspect PledgeServerHandRolled.total_pledged()

# IO.inspect Process.info(pid, :messages)
