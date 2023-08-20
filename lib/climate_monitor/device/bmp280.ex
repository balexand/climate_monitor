defmodule ClimateMonitor.Device.BMP280 do
  @behaviour ClimateMonitor.Device
  @name __MODULE__

  def child_spec([]) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link do
    BMP280.start_link(bus_name: "i2c-1", bus_address: 0x77, name: @name)
  end

  @impl true
  def measure(name \\ @name), do: BMP280.measure(name)
end
