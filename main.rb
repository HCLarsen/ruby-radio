require 'gtk3'
require 'ruby-mpd'

class MainDisplay

  LABEL_MARKUP = '<span foreground="red" font_desc="84" weight="bold">%s</span>'
  MAJOR_MARKUP = '<span foreground="red" font_desc="84" weight="bold">%s</span>'
  MINOR_MARKUP = '<span foreground="red" font_desc="16" weight="bold">%s</span>'

  def initialize
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

    #list of radio stations
    @radioList.add(Gtk::Button.new(:label => "First\nStation"))
    @radioList.add(Gtk::Button.new(:label => "Second\nStation"))
    @radioList.add(Gtk::Button.new(:label => "Third\nStation"))
    @radioList.add(Gtk::Button.new(:label => "Fourth\nStation"))
    @radioList.add(Gtk::Button.new(:label => "Fifth\nStation"))
    @radioList.add(Gtk::Button.new(:label => "Sixth\nStation"))

    @clockView.signal_connect('button-press-event') { goToMainDisplay }
    @eventbox1.signal_connect('button-press-event') { goToClockDisplay }

    @timeLabel.set_markup(MAJOR_MARKUP % clockTime)
    @timeHeader.set_markup(MINOR_MARKUP % clockTime)
    
    @win.override_background_color(:normal, Gdk::RGBA.new(0, 0, 0, 1))
    @win.signal_connect("destroy") { Gtk.main_quit }

    @win.show_all
    Gtk.main
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
        @timeLabel.set_markup(LABEL_MARKUP % clockTime)
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
