require 'gtk3'
require 'byebug'
require 'cronofy'

class String
  def camelCase
    self.split.each.with_index { |word, i| i == 0 ? word.downcase! : word.capitalize!}.join
  end
end

class Clock
  def initialize(clockLabel, app)
    @clockLabel = clockLabel
    @app = app
    @tick = true

    @cronofy_token = ENV['CRONOFY_TOKEN']
		
    @alarms = []
    loadSunriseAndSunset
#    loadAlarms

    startClock
  end

  def setLabel(clockLabel)
    @clockLabel = clockLabel
  end

  def updateHeader(time)
    if @tick
      clockText = "#{time.strftime("%H")}:#{time.strftime("%M")}"
    else
      clockText = "#{time.strftime("%H")} #{time.strftime("%M")}"
    end
    @tick = !@tick
    @clockLabel.set_text(clockText)

    @app.radio.updateStatus
  end

  private

  def checkAlarms
    Thread.new do
      if Time.now.min == 0 and Time.now.hour == 0
        loadSunriseAndSunset
      end
      if Time.now.min == 45
        loadAlarms
      end
      @alarms.each do |alarm|
        if alarm[:time].hour == Time.now.hour && alarm[:time].min == Time.now.min
          @app.instance_eval alarm[:actions]
        end
      end
    end
  end

  def loadSunriseAndSunset
    if @app.weather
      sunrise, sunset = @app.weather.sunrise_and_sunset
      @alarms << {:time => sunrise, :actions => Proc.new {setNightMode(false)}}
      @alarms << {:time => sunset, :actions => Proc.new {setNightMode}}
      @alarms = @alarms.sort_by { |hsh| hsh[:time] }    
    end
  end

  def loadAlarms
    cronofy = Cronofy::Client.new(access_token: "#{@cronofy_token}")
    alarm_cal = cronofy.list_calendars.select { |cal| cal.calendar_name == "Alarms" }.first
    events = cronofy.read_events(calendar_ids: alarm_cal.calendar_id)
    events.each do | event |
      alarm = {}
      alarm[:time] = event.start.time.localtime
      alarm[:actions] = event.description.camelCase
      @alarms << alarm
    end
    @alarms = @alarms.sort_by { |hsh| hsh[:time] }
    #byebug

    # test code
    #@alarms << {:time=> Time.now + 60,:actions => 'puts "#{self} First alarm"' }
     #@alarms << {:time=> Time.now + 120,:actions => 'puts "#{self} Second alarm"' }
    #@alarms << {:time=> Time.now + 180,:actions => 'puts "#{self} Third alarm"' }
    #@alarms = @alarms.sort_by { |hsh| hsh[:time] }
  end

  def startClock
    @tickTock = Thread.new do
      while true
        time = Time.now
        if time.sec == 0
          updateHeader(time)
          checkAlarms
          sleep 0.5
        end
        updateHeader(time)
        sleep 0.5
      end
    end
  end
end
