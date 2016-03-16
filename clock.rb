require 'gtk3'
require 'byebug'

class Clock

  def initialize(clockLabel, markup)
    @clockLabel = clockLabel
    @markup = markup
		@tick = true
    puts "Clock Initialized"
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
				clockUpdate
        sleep 0.5
      end
    end    
  end
end
