defmodule ClimateMonitor.Device do
  @callback measure() :: {:ok, BMP280.Measurement.t()} | {:error, any()}
end
