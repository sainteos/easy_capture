defmodule PollTask do
  use Task
  
  def start_link(arg) do
    Task.start_link(__MODULE__, :poll, [arg])
    
    {:ok, red_pid} = ElixirALE.GPIO.start_link(6, :input)
    {:ok, green_pid} = ElixirALE.GPIO.start_link(7, :input)    
    
    poll([red_pid, green_pid])
  end

  def poll(button_pids) do
    
    poll(button_pids)
  end
end
