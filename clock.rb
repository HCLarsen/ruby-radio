require 'gtk3'

class Clock

  #MAJOR_MARKUP = '<span foreground="red" font_desc="84" weight="bold">%s</span>'
  #MINOR_MARKUP = '<span foreground="white" font_desc="28" weight="bold">%s</span>'

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

  def clockTime
    time = Time.now
    "#{time.strftime("%H")}:#{time.strftime("%M")}"
  end

  def startClock
    @tickTock = Thread.new do
      until @interrupt do
        @clockLabel.set_markup(@markup % clockTime)
        sleep 1
      end
    end    
  end
end
