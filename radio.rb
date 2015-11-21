require 'ruby-mpd'

class Radio
  def initialize
    @mpd = MPD.new 'localhost', 6600
    @mpd.connect
  end

  def volume
    @mpd.status[:volume]
  end

	def setVolume(vol)
		@mpd.volume=vol
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
    end
  end
end
