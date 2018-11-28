require 'csv'
require 'ruby-mpd'

class Radio
  def initialize(stack, radioStatus)
    @mpd = MPD.new 'localhost', 6600
    @mpd.connect    

    @stack = stack
    @radioStatus = radioStatus
    
		@radioStations = CSV.read("#{File.expand_path(__dir__)}/../radiostations.csv").map do |row|
			{ :name=> row[0], :desc=> row[1], :addr=> row[2] }
		end
		
    loadui
  end

  def loadui
    ui_file = "#{File.expand_path(__dir__)}/../ui/radio.ui"
    builder = Gtk::Builder.new
    builder.add_from_file(ui_file)

    @radioView = builder.get_object("radioView")
    @radioList = builder.get_object("radioList")
    @playerView = builder.get_object("playerView")
    @back = builder.get_object("backButton")
    @playerBox = builder.get_object("playerBox")
    @stationInfo = builder.get_object("stationInfo")
    @volumeSlider = builder.get_object("volumeScale")

		@back.children.first.name = "bordered"
    @stationInfo.name = "stationInfo"
    @volumeSlider.name = "slider"

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

  def currentStation
    if !@mpd.playing?
      return ""
    elsif @mpd.status[:error]
      return "Error"
    else
      return @radioStations[@mpd.status[:song]][:name].split[0]
    end
  end

  def updateStatus
    @radioStatus.set_text(currentStation)
  end

  def volume
    @mpd.status[:volume]
  end

  def setVolume(vol)
    @mpd.volume = vol
  end

  def play(station)
    @stack.set_visible_child(@playerView)
    @stationInfo.set_text(@radioStations[station][:name] + "\n" + @radioStations[station][:desc])
    unless @mpd.playing? && @mpd.status[:song] == station
      @mpd.play(station)
      updateStatus
    end
  end

  def toggle
    if @mpd.playing?
      @mpd.stop
    else
      @mpd.play
    end
    updateStatus
  end

  private

  def addRadioStations(radioList)
    @mpd.clear
    @radioStations.each_with_index do |station, i|
      @mpd.add station[:addr]
      label = Gtk::Label.new
      label.name = "bordered"
      label.set_markup('<span font_desc="16">%s</span>' % station[:name] + "\n" + station[:desc])
      button = Gtk::Button.new
      button.add(label)
      button.set_alignment(0,0.5)
      button.signal_connect('clicked') { play(i)}
      radioList.add(button)
    end
  end
end
