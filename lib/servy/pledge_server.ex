defmodule Servy.PledgeServer do

  def listen_loop(state) do
    IO.puts "\nWaitting for a message"

    receive do
      {:create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_server(name, amount)
        new_state = [ {name, amount} | state ]
        IO.puts "#{name} pledged #{amount}"
        IO.puts "new state is #{inspect new_state}"

        listen_loop(new_state)
        {sender, :recent_pledges} ->
          send sender, {:response, state}
          IO.puts "Send pledges to #{inspect sender}"
          listen_loop(state)
    end
  end

  # def create_pledge(name, amount) do
  #   {:ok, id} = send_pledge_to_server(name, amount)
  #   [ {"larry", 10}]
  # end

  # def recent_pledges do

  # end
  defp send_pledge_to_server(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

end
