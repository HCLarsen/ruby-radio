require 'gtk3'

class MainDisplay

  def initialize
    button = Gtk::Button.new :label => "Clock"
    color=Gdk::RGBA::new(1.0,0.3,0.3,1.0)
    button.override_background_color(:normal, Gdk::RGBA.new(0, 0, 0, 1))
    scrolled = Gtk::ScrolledWindow.new
    scrolled.add(button)

    button2 = Gtk::Button.new :label => "Main"
    scrolled2 = Gtk::ScrolledWindow.new
    scrolled2.add(button2)

    #list of radio stations
    scrolled3 = Gtk::ScrolledWindow.new
    box = Gtk::Box.new(:vertical, 0)
    box.add(Gtk::Button.new(:label => "First\nStation"))
    box.add(Gtk::Button.new(:label => "Second\nStation"))
    box.add(Gtk::Button.new(:label => "Third\nStation"))
    box.add(Gtk::Button.new(:label => "Fourth\nStation"))
    box.add(Gtk::Button.new(:label => "Fifth\nStation"))
    box.add(Gtk::Button.new(:label => "Sixth\nStation"))
    scrolled3.add(box)

    stack = Gtk::Stack.new
    stack.add_named(scrolled, "One")
    stack.add_named(scrolled2, "Two")
    stack.add_named(scrolled3, "Three")

    button.signal_connect('clicked') { stack.set_visible_child(scrolled2) }
    button2.signal_connect('clicked') { stack.set_visible_child(scrolled3) }

    win = Gtk::Window.new("Clock")
    win.set_default_size(320,240)
    win.override_background_color(:normal, Gdk::RGBA.new(0, 0, 0, 1))
    win.signal_connect("destroy") { Gtk.main_quit }

    win.add(stack)
    win.show_all
    Gtk.main
  end
end

MainDisplay.new
