#!/usr/bin/env ruby
require_relative "scratchrsc"
require_relative "../nextbus/lib/nextbus" # This is using my local copy of my fork... hopefully we can just use the gem itself

class PrintRSC < RSCWatcher

  SCRATCH_MIN_X = -240
  SCRATCH_MIN_Y = -180
  SCRATCH_MAX_X = 240
  SCRATCH_MAX_Y = 180
  MAP_SCALE = 10000

  def initialize
    super

    # init global variables
    @agency_id = 'ttc'
    @route_id = nil

    # send broadcasts so the connected Scratch knows what they are
    broadcast "route_config"
    broadcast "vehicle_locations"

  end
  
  # when a variable or sensor is updated
  def on_sensor_update(name, value)
    value = value.to_i if %w(list of values that should be integers example_var_1).include? name
    if name == "route_id"
      @route_id = value
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

  def broadcast_route_config
    route_config
  end

  def broadcast_vehicle_locations
    get_vehicle_locations
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
  
  # Look up the route data and update some sensors etc
  def route_config
    raise StandardError, "You must set a route_id in Scratch before calling route_config"
    @route = Nextbus::Route.find @agency_id, @route_id
    sensor_update "route_title", @route.title
    set_screen_factors @route.lat_min, @route.lat_max, @route.lon_min, @route.lon_max
    set_stops
    get_vehicle_locations
  end

  # get the vehicles on the route, and do sensor_updates for each vehicle telling scratch where it is and where it is pointing
  def get_vehicle_locations
    route_config unless @route
    @last_time = Time.now if @last_time.nil?
    # TODO handle a route that has no active vehicles, like the 101 during the week
    # TODO do I need to clear sensors that aren't active... e.g. if I'm on a route with 8 buses, then switch to a route with 2, do I somehow clear those sensors I'm not using any more?
    vehicles = Nextbus::Vehicle.all @agency_id, @route_id #, @last_time
    sensor_update "vehicle_count", vehicles.size
    vehicles.each.with_index(1){|v, i|
      sensor_update "vehicle_#{i}_id", v.id
      sensor_update "vehicle_#{i}_lat", lat_factor(v.lat)
      sensor_update "vehicle_#{i}_lon", lon_factor(v.lon)
      sensor_update "vehicle_#{i}_heading", v.heading
    }
    broadcast "move_buses"
  end

  # define the factors to convert the raw GPS lat/lon to X & Y -- note, not taking into account projection of the map etc
  def set_screen_factors(lat_min, lat_max, lon_min, lon_max)
    @x_factor = 0
    @y_factor = 0
    # TODO add a border
    x_range = lon_max.to_f - lon_min.to_f
    @x_factor = (x_range * MAP_SCALE) / (SCRATCH_MAX_X - SCRATCH_MIN_X)
    y_range = lat_max.to_f - lat_min.to_f
    @y_factor = (y_range * MAP_SCALE) / (SCRATCH_MAX_Y - SCRATCH_MIN_Y)
    # TODO don't skew the map, figure on one factor and use accordingly
  end

  def set_stops
    # the nil for direction gives full stop details for all directions
    stops = Nextbus::Stop.all @agency_id, @route_id, nil
    broadcast "clear_stops"
    stops.each{|stop|
      sensor_update "stop_title", stop.title
      sensor_update "stop_lon", lon_factor(stop.lon)
      sensor_update "stop_lat", lat_factor(stop.lat)
      broadcast "add_to_stops"
    }
    broadcast "draw_stops"
  end

  def lat_factor(lat)
    lat = lat.to_f - @route.lat_min.to_f
    lat = (lat * MAP_SCALE) / @y_factor
    return lat + SCRATCH_MIN_Y
  end

  def lon_factor(lon)
    lon = lon.to_f - @route.lon_min.to_f
    lon = (lon * MAP_SCALE) / @x_factor
    return lon + SCRATCH_MIN_X
  end

end

begin
  watcher = PrintRSC.new # you can provide the host as an argument
  watcher.sensor_update "connected", "1"
  loop { watcher.handle_command }
rescue => e
  puts "\033[31m\033[1mError: #{e.message}\n#{e.backtrace.join("\n\t")}\033[00m\n"
end
