require 'ruby-mpd'

class Radio
  def initialize(stack, radioStatus)
    @mpd = MPD.new 'localhost', 6600
    @mpd.connect

    @stack = stack
    @radioStatus = radioStatus

    @radioStations = [{:name=> "Z103.5", :desc=> "Top 40", :addr=>"http://ice8.securenetsystems.net/CIDC?&playSessionID=1454B12F-A7FA-81C5-CCF8EDB05FEC18B6"},
                      {:name=> "99.9 Virgin Radio", :desc=> "Top 40", :addr=>"http://ckfm-aac.akacast.akamaistream.net/7/811/102120/v1/astral.akacast.akamaistream.net/ckfm-aac"},
                      {:name=> "93.5 The Move", :desc=> "Throwbacks", :addr=>"http://5833.live.streamtheworld.com:443/CFXJFM_SC"},
                      {:name=> "92.5 KISS FM", :desc=> "Top 40", :addr=>"http://204.2.199.166:80/7/288/80873/v1/rogers.akacast.akamaistream.net/tor925"}]

    loadui
  end

  def loadui
    ui_file = "#{File.expand_path(File.dirname(__FILE__))}/ui/radio.ui"
    builder = Gtk::Builder.new
    builder.add_from_file(ui_file)

    @radioView = builder.get_object("radioView")
    @radioList = builder.get_object("radioList")
    @playerView = builder.get_object("playerView")
    @back = builder.get_object("backButton")
    @playerBox = builder.get_object("playerBox")
    @stationInfo = builder.get_object("stationInfo")
    @volumeSlider = builder.get_object("volumeScale")

    @stationInfo.name = "stationInfo"

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
    return "" unless @mpd.playing?
    return @radioStations[@mpd.status[:song]][:name].split[0]
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
      @radioStatus.set_text(currentStation)
    end
  end

  def toggle
    if @mpd.playing?
      @mpd.stop
    else
      @mpd.play
    end
    @radioStatus.set_text(currentStation)
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
