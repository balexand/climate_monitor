defmodule ClimateMonitor do
  use GenServer

  require Logger

  @error_period :timer.minutes(1)
  @initial_delay :timer.seconds(15)
  @period :timer.minutes(1)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [Enum.into(opts, %{})]}
    }
  end

  def start_link(%{auth: _, device: _, location: _, host: _} = state) do
    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(state) do
    Process.send_after(self(), :poll, @initial_delay)
    {:ok, state}
  end

  @impl true
  def handle_info(:poll, %{device: device} = state) do
    case device.measure() do
      {:ok, measurement} ->
        Logger.debug(
          "sending measurement for #{inspect(state.location)}: #{inspect(measurement)}"
        )

        Enum.all?(~W[temperature_c pressure_pa humidity_rh dew_point_c]a, fn name ->
          push_reading(state, name, Map.fetch!(measurement, name))
        end)
        |> case do
          true -> Process.send_after(self(), :poll, @period)
          false -> Process.send_after(self(), :poll, @error_period)
        end

      {:error, error} ->
        Logger.error("climate error: #{inspect(error)}")
        Process.send_after(self(), :poll, @error_period)
    end

    {:noreply, state}
  end

  defp push_reading(%{auth: auth, location: location, host: host}, name, value) do
    case Req.post("#{host}/api/climate_readings",
           auth: auth,
           json: %{reading: %{location: location, name: name, value: value}}
         ) do
      {:ok, %{status: 201}} ->
        true

      result ->
        Logger.error("failed to push reading: #{inspect(result)}")
        false
    end
  end
end
