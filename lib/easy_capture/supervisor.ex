defmodule EasyCapture.Supervisor do
  use Supervisor
  require Logger

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
    
    Logger.info fn -> 
      "Supervisor: Supervisor has been started."
    end

    {:ok, _} = ElixirALE.GPIO.start_link(22, :input, name: RedButton)
    {:ok, _} = ElixirALE.GPIO.start_link(23, :input, name: GreenButton)
    {:ok, _} = ElixirALE.GPIO.start_link(24, :output, name: RedLED)
    {:ok, _} = ElixirALE.GPIO.start_link(25, :output, name: GreenLED)
    {:ok, _} = EasyCapture.VideoWriter.start_link([]) 
    {:ok, _} = EasyCapture.Runner.start_link([])
  end

  def init(_arg) do
    children = [
      {ElixirALE.GPIO, [22, :input, name: RedButton]},
      {ElixirALE.GPIO, [23, :input, name: GreenButton]},
      {ElixirALE.GPIO, [24, :output, name: RedLED]},
      {ElixirALE.GPIO, [25, :output, name: GreenLED]},
      {EasyCapture.VideoWriter},
      {EasyCapture.Runner}
    ]
    supervise(children, strategy: :one_for_one)
  end
end
