require 'ruby-mpd'

class Radio
  def initialize
    @mpd = MPD.new 'localhost', 6600
    @mpd.connect
		@radioStations = [{:name => "Z103.5", :desc => "Top 40", :addr=>"http://ice8.securenetsystems.net/CIDC?&playSessionID=1454B12F-A7FA-81C5-CCF8EDB05FEC18B6"},
											{:name => "99.9 Virgin Radio", :desc => "Top 40", :addr=>"http://ckfm-mp3.akacast.akamaistream.net/7/318/102120/v1/astral.akacast.akamaistream.net/ckfm-mp3"}]
  end

	def addRadioStations
		@mpd.clear
		@radioStations.each do |station|
			# must also add to radio display
			@mpd.add station[:addr]
		end
	end

  def volume
    @mpd.status[:volume]
  end

	def setVolume(vol)
		@mpd.volume = vol
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
