defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears() do
    [
      %Bear{id: 1, name: "Aaa", type: "Brown", hibernating: true},
      %Bear{id: 2, name: "Bbb", type: "Black", hibernating: true},
      %Bear{id: 3, name: "Ccc", type: "White", hibernating: true},
      %Bear{id: 4, name: "Ddd", type: "Panda", hibernating: true},
      %Bear{id: 5, name: "Eee", type: "Polar"},
      %Bear{id: 6, name: "Fdd", type: "Grizzly", hibernating: true},
      %Bear{id: 7, name: "Fad", type: "Grizzly", hibernating: true},


    ]
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn(b) -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end
