defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear
  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    IO.puts "====> controller"
    items =
      Wildthings.list_bears()
      |> Enum.filter(fn(b) -> Bear.is_grizzly(b) end)
      |> Enum.sort(&Bear.order_asc_by_name(&1,&2))# 注意这里的写法和上一行不同
      # |> Enum.sort(&Bear.order_asc_by_name/2)# 注意这里的写法和上一行不同
      |> Enum.map(&bear_item/1)
      |> Enum.join
      IO.puts items
    %{conv | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | status: 200, resp_body: "Bear #{bear.id} - #{bear.name}"}
  end

   def create(conv, params) do
    %{conv | status: 201,
            resp_body: "Create a  #{params["type"]} bear  named #{params["name"]}! " }
   end
end
