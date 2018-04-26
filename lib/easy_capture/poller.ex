defmodule EasyCapture.Poller do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, :ok, args)
    {:ok, red_led_pid} = ElixirALE.GPIO.start_link(4, :output)
    {:ok, green_led_pid} = ElixirALE.GPIO.start_link(5, :output)
    {:ok, red_button_pid} = ElixirALE.GPIO.start_link(6, :input)
    {:ok, green_button_pid} = ElixirALE.GPIO.start_link(7, :input)
    
    EasyCapture.PollTask.start_link([red_button_pid, green_button_pid])

    poll([red_led_pid, green_led_pid])
  end

  def init(:ok) do
    children = [
      {EasyCapture.PollTask, name: EasyCapture.PollTask}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

  def poll(led_pids) do
    receive do
      {:red_press} -> "Red down"
      {:red_release} -> "Red up"
      {:green_press} -> "Green down"
      {:green_release} -> "Green up"
    end
    
    poll(led_pids)
  end 
	
  
end
