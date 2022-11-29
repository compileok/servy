defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("../../templates",__DIR__)


  defp render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end

  def index(conv) do
    # items =
    #   Wildthings.list_bears()
    #   |> Enum.filter(fn(b) -> Bear.is_grizzly(b) end)
    #   |> Enum.sort(&Bear.order_asc_by_name(&1,&2))# 注意这里的写法和上一行不同
    #   # |> Enum.sort(&Bear.order_asc_by_name/2)# 注意这里的写法和上一行不同
    #   |> Enum.map(&bear_item/1)
    #   |> Enum.join
    #   IO.puts items

    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)
    
    render(conv, "index.eex", bears: bears)

  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    render(conv, "show.eex", bear: bear)
  end

   def create(conv, params) do
    %{conv | status: 201,
            resp_body: "Create a  #{params["type"]} bear  named #{params["name"]}! " }
   end
end
