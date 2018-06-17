defmodule EasyCapture.Runner do
  import IEx.Helpers
  use GenServer
  require Logger

  @red_id 24
  @green_id 25
  @led_on 0
  @led_off 1

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
    Logger.info fn ->
      "Runner: Runner is spinning up."
    end

    ElixirALE.GPIO.set_int(RedButton, :falling)
    ElixirALE.GPIO.set_int(GreenButton, :falling)
    
    flush()
    
    ElixirALE.GPIO.write(RedLED, @led_off)
    ElixirALE.GPIO.write(GreenLED, @led_off)
    
    Logger.info fn ->
      "Runner: Runner has been started."
    end
  end

  def init(arg) do 
    {:ok, arg}
  end

  def handle_call(arg) do
    {:ok, arg}
  end

  def handle_cast(:gpio_interrupt, @red_id, :falling) do
    Logger.info fn ->
      "Runner: Red was pressed!"
    end
    GenServer.cast(EasyCaptuer.Writer, :stop)
    ElixirALE.GPIO.write(RedLed, @led_on)
    ElixirALE.GPIO.write(GreenLed, @led_off)
  end
  
  def handle_cast(:gpio_interrupt, @green_id, :falling) do
    Logger.info fn ->
     "Runner: Green was pressed!"
    end
    ElixirALE.GPIO.write(RedLed, @led_off)
    ElixirALE.GPIO.write(GreenLed, @led_on)
    GenServer.cast(EasyCapture.Writer, :stop)
    GenServer.cast(EasyCapture.Writer, :start)
  end
end
