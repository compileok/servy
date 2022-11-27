defmodule Servy.Plugins do

  alias Servy.Conv


  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end
  def track(%Conv{} = conv), do: conv


  def rewrite_path(%Conv{path: "/test"} = conv) do
    %{conv | path: "/hello"}
  end
  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) , do: IO.inspect conv

end
