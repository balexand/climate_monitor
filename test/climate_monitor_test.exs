defmodule ClimateMonitorTest do
  use ExUnit.Case
  doctest ClimateMonitor

  test "greets the world" do
    assert ClimateMonitor.hello() == :world
  end
end
