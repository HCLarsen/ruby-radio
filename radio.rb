require 'gtk3'
require 'ruby-mpd'

class Radio

  MINOR_MARKUP = '<span foreground="white" font_desc="28" weight="bold">%s</span>'

  def initialize
    @mpd = MPD.new 'localhost', 6600
    @mpd.connect
    @station_names = ["Z103.5\nTop 40", 
                      "99.9 Virgin Radio\nTop 40", 
                      "Flow 93.5\nHip-Hop and R&amp;B"]

    ui_file = "#{File.expand_path(File.dirname(__FILE__))}/radio.ui"
    builder = Gtk::Builder.new
    builder.add_from_file(ui_file)

    @win = builder.get_object("window1")
    @timeBox = builder.get_object("returnBox")
    @playerBox = builder.get_object("playerBox")
    @timeLabel = builder.get_object("timeHeader")
    @stationLabel = builder.get_object("stationInfo")

    @playerBox.signal_connect('button-press-event') { toggle }

    @timeBox.override_background_color(:normal, Gdk::RGBA.new(0, 0, 0, 1))
    @playerBox.override_background_color(:normal, Gdk::RGBA.new(0, 0, 0, 1))

    @timeLabel.set_markup(MINOR_MARKUP % "12:00")

    @win.signal_connect("destroy") { Gtk.main_quit }
    @win.show_all
    Gtk.main
  end

  def toggle
    status = @mpd.status
    if status[:state] == :play
      @mpd.stop
    else
      @mpd.play
      song = @mpd.current_song
      @stationLabel.set_markup(MINOR_MARKUP % @station_names[song.pos])
    end
  end

end

Radio.new
