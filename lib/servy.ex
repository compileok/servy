defmodule Servy do

  def hello do
    :world
  end

  def hello2(name) do
    "Hello, #{name}!"
  end
end

IO.puts Servy.hello2("zhangsan")
