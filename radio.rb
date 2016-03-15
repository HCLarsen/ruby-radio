require 'ruby-mpd'

class Radio
  def initialize
    @mpd = MPD.new 'localhost', 6600
    @mpd.connect
		@radioStations = [{:name => "Z103.5", :desc => "Top 40", :addr=>"http://ice8.securenetsystems.net/CIDC?&playSessionID=1454B12F-A7FA-81C5-CCF8EDB05FEC18B6"},
											{:name => "99.9 Virgin Radio", :desc => "Top 40", :addr=>"http://ckfm-mp3.akacast.akamaistream.net/7/318/102120/v1/astral.akacast.akamaistream.net/ckfm-mp3"}]
  end

	def addRadioStations(radioList)
		@mpd.clear
		@radioStations.each_with_index do |station, i|
			# must also add to radio display
			@mpd.add station[:addr]
       label = Gtk::Label.new
       label.set_markup('<span font_desc="16">%s</span>' % station[:name] + "\n" + station[:desc])
       button = Gtk::Button.new
       button.add(label)
       button.set_alignment(0,0.5)
       button.signal_connect('clicked') { start_radio(i)}
       radioList.add(button)
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
		if @mpd.playing?
			@mpd.stop
		else
			@mpd.play
		end
  end
end
