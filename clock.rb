require 'gtk3'
require 'byebug'

class Clock
  def initialize(clockLabel, app)
    @clockLabel = clockLabel
    @app = app
    @radio = @app.radio
    @weather = @app.weather
    @tick = true
    @alarms = []
    startClock
  end

  def setLabel(clockLabel)
    @clockLabel = clockLabel
  end

  def clockUpdate
    time = Time.now
    if @tick
      clockText = "#{time.strftime("%H")}:#{time.strftime("%M")}"
    else
      clockText = "#{time.strftime("%H")} #{time.strftime("%M")}"
    end
    @tick = !@tick
    @clockLabel.set_text(clockText)    
  end

  private

  def checkAlarms
    Thread.new do
      if Time.now.min == 0 and Time.now.hour == 0
        sunrise, sunset = @app.weather.sunrise_and_sunset
        @alarms << {:time => sunrise, :actions => ["setNightMode(false)"]}
        @alarms << {:time => sunset, :actions => ["setNightMode"]}
        @alarms = alarms.sort_by { |hsh| hsh[:time] }
      end
      if Time.now.min == 45
        # download, sort and store alarms
      end
      @alarms.each do |alarm|
        if alarm[:time].hour == Time.now.hour && alarm[:time].min == Time.now.min
          # alarm[:actions].each {|command| @app.send command}
        end
      end
      sleep 1
    end
  end

  def startClock
    @tickTock = Thread.new do
      while true
        if Time.now.sec == 0
          checkAlarms
        end
        clockUpdate
        sleep 0.5
      end
    end
  end
end
