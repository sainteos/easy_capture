defmodule EasyCapture.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, :ok, args)

    {:ok, red_led_pid} = ElixirALE.GPIO.start_link(4, :output)
    {:ok, green_led_pid} = ElixirALE.GPIO.start_link(5, :output)
    {:ok, red_button_pid} = ElixirALE.GPIO.start_link(6, :input)
    {:ok, green_button_pid} = ElixirALE.GPIO.start_link(7, :input)
    {:ok, video_writer} = VideoWriter.start_link([]) 
    
    {:ok, runner} = EasyCapture.Runner.start_link(red_led_pid, green_led_pid,
      red_button_pid, green_button_pid, video_writer)
  end

  def init(_arg) do
    children = [
      {ElixirALE.GPIO, [4, :output]},
      {ElixirALE.GPIO, [5, :output]},
      {ElixirALE.GPIO, [6, :input]},
      {ElixirALE.GPIO, [7, :input]},
      {EasyCapture.VideoWriter},
      {EasyCapture.Runner}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
