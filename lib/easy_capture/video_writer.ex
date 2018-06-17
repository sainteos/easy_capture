defmodule EasyCapture.VideoWriter do
  use GenServer
  require Logger

  def start_link(args) do
    Logger.info fn ->
      "VideoWriter: Video writer has been started."
    end
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_record() do
    Logger.info fn ->
      "VideoWriter: Recording has begun!"
    end

    import FFmpex
    import FFmpex.Options
    import FFmpex.Options.Main
    command = 
      FFmpex.new_command
      |> add_global_option(option_y())
      |> add_input_file("/dev/video0")
      |> add_input_file("hw:0")
        |> add_file_option(option_f("alsa"))
      |> add_output_file("~/output.mp4")
        |> add_stream_specifier(stream_type: :video)
        

    :ok = execute(command)  
  end

  def kill_record_cmd() do
    Logger.info fn ->
      "VideoWriter: Attempting to kill ffmpeg..."
    end
    System.cmd("killall",["INT", "ffmpeg"])
  end

  def init(arg) do
    {:ok, arg}
  end
  
  def handle_call(arg) do
    {:ok, arg}
  end
  
  def handle_cast(:start) do
    kill_record_cmd()
    spawn(EasyCapture, :start_record, [])
  end

  def handle_cast(:stop) do
    kill_record_cmd()
  end
end
