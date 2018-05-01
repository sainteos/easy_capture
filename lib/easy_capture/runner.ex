defmodule EasyCapture.Runner do
  use GenServer
  @red_id 24
  @green_id 25

  def start_link(red_led, green_led, red_button, green_button, writer) do
    GenServer.start_link(__MODULE__, [], __MODULE__)
    
    ElixirALE.GPIO.set_int(red_button, :falling)
    ElixirALE.GPIO.set_int(green_button, :falling)
    receive do
      {:gpio_interrupt, _, _} -> true
    end
    receive do
      {:gpio_interrupt, _, _} -> true
    end
    
    ElixirALE.GPIO.write(red_led, 1)

    poll(red_led, green_led, red_button, green_button, writer, false)
  end

  def poll(red_led, green_led, red_button, green_button,
      writer, writing) do
    receive do
      {:gpio_interrupt, @red_id, :falling} when writing == false ->
        poll(red_led, green_led, red_button, green_button, writer, false)
      {:gpio_interrupt, @red_id, :falling} when writing == true ->
        send(writer, :stop)
        ElixirALE.GPIO.write(red_led, 1)
        ElixirALE.GPIO.write(green_led, 0)
        poll(red_led, green_led, red_button, green_button, writer, false)
      {:gpio_interrupt, @green_id, :falling} when writing == false ->
        send(writer, :start)
        ElixirALE.GPIO.write(red_led, 0)
        ElixirALE.GPIO.write(green_led, 1)
        poll(red_led, green_led, red_button, green_button, writer, true)
      {:gpio_interrupt, @green_id, :falling} when writing == true ->
        send(writer, :stop)
        send(writer, :start)
        poll(red_led, green_led, red_button, green_button, writer, true) 
    end  
  end
end
