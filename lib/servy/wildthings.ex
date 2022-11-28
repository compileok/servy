defmodule Servy.Wildthings do
  alias Servy.Bear
  
  def list_bears() do
    [
      %Bear{id: 1, name: "Aaa", type: "Brown", hibernating: true},
      %Bear{id: 2, name: "Bbb", type: "Black", hibernating: true},
      %Bear{id: 3, name: "Ccc", type: "White", hibernating: true},
      %Bear{id: 4, name: "Ddd", type: "Panda", hibernating: true},
      %Bear{id: 4, name: "Eee", type: "Polar"}
    ]
  end
end