require 'gtk3'
require 'byebug'

class Clock

  def initialize(clockLabel, markup)
    @clockLabel = clockLabel
    @markup = markup
		@tick = true
		@alarm = Thread.new {}
		startClock
  end

  def setLabel(clockLabel)
    @clockLabel = clockLabel
  end

  def setMarkup(markup)
    @markup = markup
  end

	def clockUpdate
    time = Time.now
		if @tick
			@clockLabel.set_markup(@markup % ("#{time.strftime("%H")}:#{time.strftime("%M")}"))
		else
			@clockLabel.set_markup(@markup % ("#{time.strftime("%H")} #{time.strftime("%M")}"))
		end
		@tick = !@tick
	end

	private

  def startClock
    @tickTock = Thread.new do
      until @interrupt do
				if Time.now.sec == 0 && !@alarm.status
					@alarm = Thread.new do
						# check the alarms and activate
						sleep 1
					end
				end
				clockUpdate
        sleep 0.5
      end
    end    
  end
end
