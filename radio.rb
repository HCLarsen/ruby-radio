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
  end

  def play(station)
    @mpd.play(station)
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
