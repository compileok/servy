defmodule Servy.BearController do

  alias Servy.Wildthings 
  
  def index(conv) do
    bears = Wildthings.list_bears()
    %{conv | status: 200, resp_body: "Elixir In Action, Elixir CookBook"}
  end

  def show(conv, %{"id" => id}) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

   def create(conv, params) do
    %{conv | status: 201,
            resp_body: "Create a  #{params["type"]} bear  named #{params["name"]}! " }
   end
end
