defmodule Runner do
  use GenServer
  @red_id = 6
  @green_id = 7

  def start_link(red_led, green_led, red_button, green_button, writer) do
    GenServer.start_link(__MODULE__, arg, __MODULE__)
    
    GPIO.set_int(red_button, :falling)
    GPIO.set_int(green_button, :falling)
    flush

    GPIO.write(red_led, 1)

    poll(red_led, green_led, red_button, green_button, writer)
  end

  def poll(red_led, green_led, red_button, green_button,
      writer, writing // false) do
    recieve do
      {:gpio_interrupt, @red_id, :falling} when writing == false ->
        poll(red_led, green_led, red_button, green_button, writer)
      {:gpio_interrupt, @red_id, :falling} when writing == true ->
        send(writer, :stop)
        GPIO.write(red_led, 1)
        GPIO.write(green_led, 0)
        poll(red_led, green_led, red_button, green_button, writer)
      {:gpio_interrupt, @green_id, :falling} when writing == false ->
        send(writer, :start)
        GPIO.write(red_led, 0)
        GPIO.write(green_led, 1)
        poll(red_led, green_led, red_button, green_button, writer, true)
      {:gpio_interrupt, @green_id, :falling} when writing == true ->
        send(writer, :stop)
        send(writer, :start)
        poll(red_led, green_led, red_button, green_button, writer, true) 
    end  
  end
end
