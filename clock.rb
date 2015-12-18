require 'gtk3'

class Clock

  def initialize(clockLabel, markup)
    @clockLabel = clockLabel
    @markup = markup
    puts "Clock Initialized"
  end

  def setLabel(clockLabel)
    @clockLabel = clockLabel
  end

  def setMarkup(markup)
    @markup = markup
  end

	def clockUpdate
    time = Time.now
		@clockLabel.set_markup(@markup % "#{time.strftime("%H")}:#{time.strftime("%M")}")
	end

  def startClock
    @tickTock = Thread.new do
      until @interrupt do
				clockUpdate
        sleep 1
      end
    end    
  end
end
