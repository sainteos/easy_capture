defmodule EasyCapture do
  use Application
  
  def start(_type, _args) do
    EasyCapture.Supervisor.start_link(name: EasyCapture.Supervisor)
  end

end
