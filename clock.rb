require 'gtk3'
require 'byebug'

class Clock

  def initialize(clockLabel)
    @clockLabel = clockLabel
    @tick = true
    @alarm = Thread.new {}
    startClock
  end

  def setLabel(clockLabel)
    @clockLabel = clockLabel
  end

  def clockUpdate
    time = Time.now
    if @tick
      @clockLabel.set_text("#{time.strftime("%H")}:#{time.strftime("%M")}")
    else
      @clockLabel.set_text("#{time.strftime("%H")} #{time.strftime("%M")}")
    end
    @tick = !@tick
  end

  private

  def startClock
    @tickTock = Thread.new do
      while true
        if Time.now.sec == 0 && !@alarm.status
          @alarm = Thread.new do
            # check the alarms and activate
            sleep 1
          end
        elsif Time.now.sec == 0 && Time.now.min == 45
          # download and store alarms
        end
        clockUpdate
        sleep 0.5
      end
    end
  end
end
