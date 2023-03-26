defmodule Servy.Api.BearController do

def index(conv) do
    IO.puts "====== Api.BearController ======"

    json =
    Servy.Wildthings.list_bears()
    #|> Posion.encode!
    |> Jason.encode!

    %{conv | status: 200, resp_content_type: "application/json",resp_body: json}
  end
end
