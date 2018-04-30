defmodule MyApp.VideoWriter
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
    wait_for_input([])
  end

  def wait_for_input([]) do
    receive do
      {_, :start} ->
        {:ok,  rec_pid} = spawn(start_record)
        wait_for_input([rec_pid]
      {_, :stop} -> wait_for_input([])
    end
  end 

  def wait_for_input([rec_pid])
    receive do
      {_, :start} ->
        exit(rec_pid, :stop_recording)
        {:ok, new_rec_pid} = spawn(start_record)
        wait_for_input([new_rec_pid])
      {_, :stop} ->
         exit(rec_pid, :stop_recording)
         wait_for_input([])
    end

  def start_record() do
    import FFmpex
    use FFmpex.Options

    command = 
      FFmpex.new_command
      |> add_global_option(option_y())
      |> add_input_file("/dev/video0")
      |> add_input_file("hw:0")
        |> f("alsa")
      |> add_output_file("~/output.mp4")
        |> add_stream_specifier(stream_type: :video)
        

    :ok = execute(command)  
  end
end
