defmodule Servy.Tracker do
  def get_location(wildthing) do

    :timer.sleep(500)

    location = %{
      "roscoe" => %{lat: "44.4280 N", lng: "110.5885 W"},
      "smokey" => %{lat: "48.4280 N", lng: "113.5885 W"},
      "brutus" => %{lat: "43.4280 N", lng: "100.5885 W"},
      "bigfoot" => %{lat: "47.4280 N", lng: "98.5885 W"},
    }

    Map.get(location, wildthing)
  end
end
