require 'gtk3'

class MainDisplay

  def initialize
    ui_file = "#{File.expand_path(File.dirname(__FILE__))}/main.ui"
    builder = Gtk::Builder.new
    builder.add_from_file(ui_file)

    #creates objects from the builder
    win = builder.get_object("win")
    stack = builder.get_object("stack")
    clockView = builder.get_object("clockView")
    timeLabel = builder.get_object("timeLabel")
    radioList = builder.get_object("radioList")
    eventbox1 = builder.get_object("eventbox1")
    radioView = builder.get_object("radioView")

    #list of radio stations
    radioList.add(Gtk::Button.new(:label => "First\nStation"))
    radioList.add(Gtk::Button.new(:label => "Second\nStation"))
    radioList.add(Gtk::Button.new(:label => "Third\nStation"))
    radioList.add(Gtk::Button.new(:label => "Fourth\nStation"))
    radioList.add(Gtk::Button.new(:label => "Fifth\nStation"))
    radioList.add(Gtk::Button.new(:label => "Sixth\nStation"))

    clockView.signal_connect('button-press-event') { stack.set_visible_child(radioView) }
    eventbox1.signal_connect('button-press-event') { stack.set_visible_child(clockView) }
    
    win.override_background_color(:normal, Gdk::RGBA.new(0, 0, 0, 1))
    win.signal_connect("destroy") { Gtk.main_quit }

    win.add(stack)
    win.show_all
    Gtk.main
  end
end

MainDisplay.new
