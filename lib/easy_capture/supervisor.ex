defmodule EasyCapture.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)

    {:ok, red_led_pid} = ElixirALE.GPIO.start_link(22, :output)
    {:ok, green_led_pid} = ElixirALE.GPIO.start_link(23, :output)
    {:ok, red_button_pid} = ElixirALE.GPIO.start_link(24, :input)
    {:ok, green_button_pid} = ElixirALE.GPIO.start_link(25, :input)
    {:ok, video_writer} = EasyCapture.VideoWriter.start_link([]) 
    
    {:ok, _} = EasyCapture.Runner.start_link(red_led_pid, green_led_pid,
      red_button_pid, green_button_pid, video_writer)
  end

  def init(_arg) do
    children = [
      {ElixirALE.GPIO, [22, :output]},
      {ElixirALE.GPIO, [23, :output]},
      {ElixirALE.GPIO, [24, :input]},
      {ElixirALE.GPIO, [25, :input]},
      {EasyCapture.VideoWriter},
      {EasyCapture.Runner}
    ]
    supervise(children, strategy: :one_for_one)
  end
end
