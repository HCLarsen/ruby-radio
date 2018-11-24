require "resolv"
require_relative 'lib/clock'
require_relative 'lib/radio'
require_relative 'lib/weather'

class MainDisplay

  def initialize
    loadUi

    @radio = Radio.new(@mainStack, @radioStatus)
    @weather = Weather.new(@mainStack)
    @clock = Clock.new(@timeLabel, self)

    if @weather
      sunrise, sunset = @weather.sunrise_and_sunset
      if sunrise && sunset && Time.now > sunrise && Time.now < sunset
         setNightMode(false)
      else
        setNightMode(true)
      end
    else
      setNightMode(false)
    end

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
    ui_file = "#{File.expand_path(__dir__)}/ui/main.ui"
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
    @radioStatus = builder.get_object("radioStatus")
    @clockButton = builder.get_object("clockButton")
    @radioButton = builder.get_object("radioButton")
    @weatherButton = builder.get_object("weatherButton")

    @timeLabel.name = "timeLabel"
    @mainClock.name = "mainClock"
    @radioStatus.name = "radioStatus"

    @radioStatus.width_chars = 6
    @radioStatus.max_width_chars = 6
  end

  def setNightMode(night = true)
    provider = Gtk::CssProvider.new
    if night
      provider.load(:path => "#{File.expand_path(__dir__)}/stylesheets/night.css")
    else
      provider.load(:path => "#{File.expand_path(__dir__)}/stylesheets/day.css")
    end
    apply_css(@win, provider)
  end

  def wakeUp(station = 0)
    goToMainDisplay
    @radio.play station
  end

  def weather
    @weather
  end

  def radio
    @radio
  end

  def goToDisplay(display)
    @mainStack.set_visible_child(display)
  end

  def goToClockDisplay
    @topStack.set_visible_child(@clockView)
    @clock.setLabel(@timeLabel)
    @clock.updateHeader(Time.now)
  end

  def goToMainDisplay
    @topStack.set_visible_child(@mainView)
    @clock.setLabel(@mainClock)
    @clock.updateHeader(Time.now)
  end

  private

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
