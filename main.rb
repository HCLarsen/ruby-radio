#require 'gtk3'
require_relative 'radio'
require_relative 'clock'

class MainDisplay

  MAJOR_MARKUP = '<span foreground="red" font_desc="84" weight="bold">%s</span>'
  MINOR_MARKUP = '<span foreground="white" font_desc="28" weight="bold">%s</span>'

  def initialize
    @station_names = ["Z103.5\nTop 40", 
                      "99.9 Virgin Radio\nTop 40", 
                      "Flow 93.5\nHip-Hop and R&amp;B"]

    loadUi

    @radio = Radio.new
    @clock = Clock.new(@timeLabel, MAJOR_MARKUP)

		@volume.set_range(0,100)
		@volume.set_value(@radio.volume)

    @clockView.signal_connect('button-press-event') { goToMainDisplay }
    @mainHeader.signal_connect('button-press-event') { goToClockDisplay }
		@radioHeader.signal_connect('button-press-event') { goToMainDisplay }
		@playerBox.signal_connect('button-press-event') { @radio.toggle }
		@volume.signal_connect('value_changed') { @radio.setVolume(@volume.value.to_i) }

    @win.override_background_color(:normal, Gdk::RGBA.new(0, 0, 0, 1))
    @win.signal_connect("destroy") { Gtk.main_quit }

    @clock.startClock
    goToClockDisplay

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
    @mainClock = builder.get_object("mainClock")
    @radioList = builder.get_object("radioList")

    @radioView = builder.get_object("radioView")
    @radioHeader = builder.get_object("radioHeader")
    @radioClock = builder.get_object("radioClock")
    @playerBox = builder.get_object("playerBox")
    @stationInfo = builder.get_object("stationInfo")
		@volume = builder.get_object("volumeScale")

    @station_names.count.times do |n |
       label = Gtk::Label.new
       label.set_markup('<span font_desc="16">%s</span>' % @station_names[n])
       button = Gtk::Button.new
       button.add(label)
       button.set_alignment(0,0.5)
       button.signal_connect('clicked') { start_radio(n)}
       @radioList.add(button)
    end
  end

  def clockTime
    time = Time.now
    "#{time.strftime("%H")}:#{time.strftime("%M")}"
  end

  def goToClockDisplay
    @stack.set_visible_child(@clockView)
    @clock.setLabel(@timeLabel)
    @clock.setMarkup(MAJOR_MARKUP)
  end

  def goToMainDisplay
    @stack.set_visible_child(@mainView)
    @clock.setLabel(@mainClock)
    @clock.setMarkup(MINOR_MARKUP)
  end

  def goToRadioPlayer
    @stack.set_visible_child(@radioView)
    @clock.setLabel(@radioClock)
    @clock.setMarkup(MINOR_MARKUP)
  end

  def start_radio(station)
    @radio.play(station)
		@stationInfo.set_markup(MINOR_MARKUP % @station_names[station])
		goToRadioPlayer
  end
end

MainDisplay.new
