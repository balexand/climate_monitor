defmodule ClimateMonitor.Device.Dummy do
  @behaviour ClimateMonitor.Device

  @impl true
  def measure do
    {:ok,
     %BMP280.Measurement{
       temperature_c: 25.43682939713035,
       pressure_pa: 87470.36626054143,
       altitude_m: 1115.0353259828232,
       humidity_rh: 56.752533713953035,
       dew_point_c: 16.23165965089818,
       gas_resistance_ohms: :unknown,
       timestamp_ms: 636_515
     }}
  end
end
