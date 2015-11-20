require 'gtk3'
require_relative 'radio'
require_relative 'clock'

class MainDisplay

  MAJOR_MARKUP = '<span foreground="red" font_desc="84" weight="bold">%s</span>'
  MINOR_MARKUP = '<span foreground="white" font_desc="28" weight="bold">%s</span>'

  def initialize
    @radio = Radio.new
    @clock = Clock.new
    
    @station_names = ["Z103.5\nTop 40", 
                      "99.9 Virgin Radio\nTop 40", 
                      "Flow 93.5\nHip-Hop and R&amp;B"]
    loadUi

    @station_names.count.times do |n |
       label = Gtk::Label.new
       label.set_markup('<span font_desc="16">%s</span>' % @station_names[n])
       button = Gtk::Button.new
       button.add(label)
       button.set_alignment(0,0.5)
       @radioList.add(button)
    end

    @timeLabel.set_markup(MAJOR_MARKUP % clockTime)
    @mainClock.set_markup(MINOR_MARKUP % clockTime)
    @radioClock.set_markup(MINOR_MARKUP % clockTime)
    
    @clockView.signal_connect('button-press-event') { goToMainDisplay }
    @mainHeader.signal_connect('button-press-event') { goToClockDisplay }

    @win.override_background_color(:normal, Gdk::RGBA.new(0, 0, 0, 1))
    @win.signal_connect("destroy") { Gtk.main_quit }

    @win.show_all
    Gtk.main
  end

  def loadUi
    ui_file = "#{File.expand_path(File.dirname(__FILE__))}/main.ui"
    builder = Gtk::Builder.new
    builder.add_from_file(ui_file)

    #creates objects from the builder
    @win = builder.get_object("win")
    @stack = builder.get_object("stack")
    @clockView = builder.get_object("clockView")
    @timeLabel = builder.get_object("timeLabel")
    @mainView = builder.get_object("mainView")
    @mainHeader = builder.get_object("mainHeader")
    @timeHeader = builder.get_object("mainClock")
    @radioList = builder.get_object("radioList")
    @radioHeader = builder.get_object("radioHeader")
    @radioClock = builder.get_object("radioClock")
    @playerBox = builder.get_object("playerBox")
    @stationInfo = builder.get_object("stationInfo")
  end

  def clockTime
    time = Time.now
    "#{time.strftime("%H")}:#{time.strftime("%M")}"
  end

  def goToClockDisplay
    @stack.set_visible_child(@clockView)
    runClock(@timeLabel, MAJOR_MARKUP)
  end

  def goToMainDisplay
    @stack.set_visible_child(@mainView)
    runClock(@mainClock, MINOR_MARKUP)
  end

  def runClock(clockLabel, markup)
    @interrupt = false
    @clock = Thread.new do
      until @interrupt do
        clockLabel.set_markup(markup % clockTime)
        sleep 1
      end
    end    
  end

  def start_radio(station)
    # Signal connect action for radio list buttons
  end
end

MainDisplay.new
