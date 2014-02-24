#!/usr/bin/env ruby
require_relative "scratchrsc"

class PrintRSC < RSCWatcher

  def initialize
    super

    # init global variables
    @example_var_1 = 0

    # send broadcasts so the connected Scratch knows what they are
    #broadcast "example"

  end
  
  # when a variable or sensor is updated
  def on_sensor_update(name, value)
    value = value.to_i if %w(list of values that should be integers example_var_1).include? name
    if name == "example_var_1"
      @example_var_1 = value
    elsif name == "example_var_2"
      @example_var_2 = value
    end
    puts "#{name} assigned #{value}"
    # whenever a global variable is changed in Scratch, optionally trigger code to run here, and/or broadcast back to scratch
    if name == "example3"
      #example3
      broadcast("example3")
    end
  end

  # code to run when we recieve a broadcast of "example_b1"
  def broadcast_example_b1
  end

  # if we recieve a broadcast we haven't already accounted for above
  def on_broadcast(name)
    (action, argument) = name.split('_')
    case action
    when "undefined_broadcast_1"
      # do something
    when "undefined_broadcast_2"
      # do something else
    end
  end

  private

  # define methods etc used in the above broadcasts etc
end

begin
  watcher = PrintRSC.new # you can provide the host as an argument
  watcher.sensor_update "connected", "1"
  loop { watcher.handle_command }
rescue => e
  puts "\033[31m\033[1mError: #{e.message}\n#{e.backtrace.join("\n\t")}\033[00m\n"
end
