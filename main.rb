require_relative 'clock'
require_relative 'radio'
require_relative 'weather'

class MainDisplay

  def initialize
    loadUi

    @clock = Clock.new(@timeLabel)
    @radio = Radio.new(@mainStack)
		@weather = Weather.new(@mainStack)

    provider = Gtk::CssProvider.new
    Dir.chdir(__dir__) do
      provider.load(:data => File.read("day.css"))
    end

    apply_css(@win, provider)
    apply_css(@timeLabel, provider)

    @clockView.signal_connect('button-press-event') {goToMainDisplay}
    @mainHeader.signal_connect('button-press-event') {goToDisplay(@appView)}
    @clockButton.signal_connect('button-press-event') {goToClockDisplay}
    @radioButton.signal_connect('button-press-event') {goToDisplay(@radio.view)}
		@weatherButton.signal_connect('button-press-event') {goToDisplay(@weather.view)}

    @win.override_background_color(:normal, Gdk::RGBA.new(0, 0, 0, 1))
    @win.signal_connect("destroy") { Gtk.main_quit }

    goToClockDisplay

    @win.show_all

    Gtk.main
  end

  def loadUi
    ui_file = "#{File.expand_path(File.dirname(__FILE__))}/main.ui"
    builder = Gtk::Builder.new
    builder.add_from_file(ui_file)

    @win = builder.get_object("win")
    @topStack = builder.get_object("topStack")
    @mainStack = builder.get_object("mainStack")
    @appView = builder.get_object("appList")
    @clockView = builder.get_object("clockView")
    @timeLabel = builder.get_object("timeLabel")
    @mainView = builder.get_object("mainView")
    @mainHeader = builder.get_object("mainHeader")
    @mainClock = builder.get_object("mainClock")
    @clockButton = builder.get_object("clockButton")
    @radioButton = builder.get_object("radioButton")
		@weatherButton = builder.get_object("weatherButton")

    @timeLabel.name = "timeLabel"
    @mainClock.name = "mainClock"
  end

  def goToDisplay(display)
  	@mainStack.set_visible_child(display)
  end

  def goToClockDisplay
    @topStack.set_visible_child(@clockView)
    @clock.setLabel(@timeLabel)
    @clock.clockUpdate
  end

  def goToMainDisplay
    @topStack.set_visible_child(@mainView)
    @clock.setLabel(@mainClock)
    @clock.clockUpdate
  end

  def apply_css(widget, provider)
    widget.style_context.add_provider(provider, GLib::MAXUINT)
    if widget.is_a?(Gtk::Container)
      widget.each_all do |child|
        apply_css(child, provider)
      end
    end
  end
end

MainDisplay.new
