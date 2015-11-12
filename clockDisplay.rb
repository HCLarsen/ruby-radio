# Basic clock app using gtk3 gem
# Written by Chris Larsen

require "gtk3"

class ClockDisplay

  LABEL_MARKUP = '<span foreground="red" background="black" font_desc="84" weight="bold">%s</span>'

  def initialize

    @timeLabel = Gtk::Label.new.set_markup(LABEL_MARKUP % clockTime)
    @tock = true

    # Initialize the button
    button = Gtk::Button.new
    button.override_background_color :normal, Gdk::RGBA::new(0.2, 0.2, 0.2, 1)
    #button.add(@timeLabel)
    button.signal_connect('clicked') { puts "Clicked" }

    # Initialize the enclosing box
    # box = Gtk::Box.new(:vertical)

    # Initialize the window itself
    win = Gtk::Window.new('Clock')
    win.set_default_size(320,240)
    win.signal_connect('destroy') { Gtk.main_quit }

    win.add(button)
    win.show_all
    Gtk.main
  end

  def tick
    @tock = !@tock
    @timeLabel.set_markup(LABEL_MARKUP % clockTime)
  end

  def clockTime
    time = Time.now
    "#{time.hour}:#{time.min}"
  end
end

ClockDisplay.new
