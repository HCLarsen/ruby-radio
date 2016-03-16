require_relative 'clock'
require_relative 'radio'

class MainDisplay

  MAJOR_MARKUP = '<span foreground="red" font_desc="monospace bold 84">%s</span>'
  MINOR_MARKUP = '<span foreground="white" font_desc="monospace bold 28">%s</span>'

  def initialize
    @station_names = ["Z103.5\nTop 40", 
                      "99.9 Virgin Radio\nTop 40", 
                      "Flow 93.5\nHip-Hop and R&amp;B"]

    loadUi

    @radio = Radio.new(@mainStack, @radioList, @playerView)
    @clock = Clock.new(@timeLabel, MAJOR_MARKUP)

    @clockView.signal_connect('button-press-event') { goToMainDisplay }
    @mainHeader.signal_connect('button-press-event') { goToClockDisplay }
		@radioButton.signal_connect('button-press-event') { goToRadioDisplay }
		@playerBox.signal_connect('button-press-event') { @radio.toggle }

		@volume.signal_connect('value_changed') { @radio.setVolume(@volume.value.to_i) }
		@volume.set_range(0,100)
		@volume.set_value(@radio.volume)

    @win.override_background_color(:normal, Gdk::RGBA.new(0, 0, 0, 1))
    @win.signal_connect("destroy") { Gtk.main_quit }

    goToClockDisplay

    @win.show_all

		#if (system "rvm") == nil # RVM is not installed in deployment environment
		#	@win.fullscreen
		#	@win.window.set_cursor(Gdk::Cursor.new(Gdk::Cursor::BLANK_CURSOR))
		#end

    Gtk.main
  end

  def loadUi
    ui_file = "#{File.expand_path(File.dirname(__FILE__))}/main.ui"
    builder = Gtk::Builder.new
    builder.add_from_file(ui_file)

    #creates objects from the builder
    @win = builder.get_object("win")
    @topStack = builder.get_object("topStack")
		@mainStack = builder.get_object("mainStack")
    @clockView = builder.get_object("clockView")
    @timeLabel = builder.get_object("timeLabel")
    @mainView = builder.get_object("mainView")
    @mainHeader = builder.get_object("mainHeader")
    @mainClock = builder.get_object("mainClock")
		@radioButton = builder.get_object("radioButton")
    @radioView = builder.get_object("radioView")
    @radioList = builder.get_object("radioList")

		@playerView = builder.get_object("playerView")
    @playerBox = builder.get_object("playerBox")
    @stationInfo = builder.get_object("stationInfo")
		@volume = builder.get_object("volumeScale")
  end

	def goToDisplay(display)
		@stack.set_visible_child(display)
		@clock.clockUpdate
	end

	def goToRadioDisplay
		@mainStack.set_visible_child(@radioView)
	end

  def goToClockDisplay
    @topStack.set_visible_child(@clockView)
    @clock.setLabel(@timeLabel)
    @clock.setMarkup(MAJOR_MARKUP)
		@clock.clockUpdate
  end

  def goToMainDisplay
    @topStack.set_visible_child(@mainView)
    @clock.setLabel(@mainClock)
    @clock.setMarkup(MINOR_MARKUP)
		@clock.clockUpdate
  end
end

MainDisplay.new
