require 'ruby-mpd'

class Radio
  def initialize(stack)
    @mpd = MPD.new 'localhost', 6600
    @mpd.connect

		@stack = stack

		@radioStations = [{:name => "Z103.5", :desc => "Top 40", :addr=>"http://ice8.securenetsystems.net/CIDC?&playSessionID=1454B12F-A7FA-81C5-CCF8EDB05FEC18B6"},
											{:name => "99.9 Virgin Radio", :desc => "Top 40", :addr=>"http://ckfm-mp3.akacast.akamaistream.net/7/318/102120/v1/astral.akacast.akamaistream.net/ckfm-mp3"}]

		loadui
  end

	def loadui
    ui_file = "#{File.expand_path(File.dirname(__FILE__))}/radio.ui"
    builder = Gtk::Builder.new
    builder.add_from_file(ui_file)

    @radioView = builder.get_object("radioView")
    @radioList = builder.get_object("radioList")
    @playerView = builder.get_object("playerView")
		@back = builder.get_object("backButton")
    @playerBox = builder.get_object("playerBox")
    @stationInfo = builder.get_object("stationInfo")
    @volumeSlider = builder.get_object("volumeScale")

		@back.signal_connect('button-press-event') {@stack.set_visible_child(@radioView) }
		@playerBox.signal_connect('button-press-event') {toggle}
		@volumeSlider.signal_connect('value_changed') { setVolume(@volumeSlider.value.to_i) }
    @volumeSlider.set_range(0,100)
    @volumeSlider.set_value(volume)

		@stack.add(@radioView)
		@stack.add(@playerView)
		addRadioStations(@radioList)
	end

	def view
		@radioView
	end

  def volume
    @mpd.status[:volume]
  end

	def setVolume(vol)
		@mpd.volume = vol
	end

  def play(station)
		@stack.set_visible_child(@playerView)
		@stationInfo.set_markup('<span foreground="white" font_desc="monospace bold 20">%s</span>' % (@radioStations[station][:name] + "\n" + @radioStations[station][:desc]))
    @mpd.play(station)
  end

  def toggle
		if @mpd.playing?
			@mpd.stop
		else
			@mpd.play
		end
  end

	private

	def addRadioStations(radioList)
		@mpd.clear
		@radioStations.each_with_index do |station, i|
			@mpd.add station[:addr]
			label = Gtk::Label.new
      label.set_markup('<span font_desc="16">%s</span>' % station[:name] + "\n" + station[:desc])
      button = Gtk::Button.new
      button.add(label)
      button.set_alignment(0,0.5)
      button.signal_connect('clicked') { play(i)}
      radioList.add(button)
		end
	end
end
