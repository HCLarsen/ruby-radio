require 'gtk3'
require 'ruby-mpd'

class MainDisplay

  MAJOR_MARKUP = '<span foreground="red" font_desc="84" weight="bold">%s</span>'
  MINOR_MARKUP = '<span foreground="white" font_desc="28" weight="bold">%s</span>'

  def initialize
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
    @timeHeader.set_markup(MINOR_MARKUP % clockTime)
    
    @clockView.signal_connect('button-press-event') { goToMainDisplay }
    @eventbox1.signal_connect('button-press-event') { goToClockDisplay }

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
    @radioView = builder.get_object("radioView")
    @eventbox1 = builder.get_object("eventbox1")
    @timeHeader = builder.get_object("timeHeader")
    @radioList = builder.get_object("radioList")
  end

  def clockTime
    time = Time.now
    "#{time.strftime("%H")}:#{time.strftime("%M")}"
  end

  def goToClockDisplay
    @stack.set_visible_child(@clockView)
    @interrupt = false
    @clock = Thread.new do
      until @interrupt do 
        @timeLabel.set_markup(MAJOR_MARKUP % clockTime)
        sleep 1
      end
    end
  end

  def goToMainDisplay
    @interrupt = true
    @stack.set_visible_child(@radioView)
    @clock = Thread.new do
      until @interrupt do
        @timeHeader.set_markup(MINOR_MARKUP % clockTime)
        sleep 1
      end
    end
  end

  def start_radio(station)
    # Signal connect action for radio list buttons
  end
end

MainDisplay.new
