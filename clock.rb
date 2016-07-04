require 'gtk3'
require 'byebug'

class Clock
  def initialize(clockLabel, app)
    @clockLabel = clockLabel
    @app = app
    @tick = true

    @alarms = []
    loadSunriseAndSunset
    loadAlarms

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
          @app.instance_eval &alarm[:actions]
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
    # test code
    #@alarms << {:time=> Time.now + 60,:actions => Proc.new { puts "#{self} First alarm" }}
    #@alarms << {:time=> Time.now + 120,:actions => Proc.new { puts "#{self} Second alarm" }}
    #@alarms << {:time=> Time.now + 180,:actions => Proc.new { puts "#{self} Third alarm" }}
    #@alarms = @alarms.sort_by { |hsh| hsh[:time] }
    # download, sort and store alarms
  end

  def startClock
    @tickTock = Thread.new do
      while true
        time = Time.now
        if time.sec == 0
          clockUpdate(time)
          checkAlarms
          sleep 0.5
        end
        clockUpdate(time)
        sleep 0.5
      end
    end
  end
end
