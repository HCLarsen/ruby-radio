require 'open-uri'
require 'json'

class Weather
  def initialize(stack)
    @stack = stack

    loadui

    #if ENV['WEATHER_TOKEN']
      # load the standard ui
    #else
    #  connectionError
    #end
  end

  def loadui
    ui_file = "#{File.expand_path(File.dirname(__FILE__))}/ui/weather.ui"
    builder = Gtk::Builder.new
    builder.add_from_file(ui_file)

    @weatherView = builder.get_object("weatherView")
    @mainImage = builder.get_object("mainImage")
    @mainLabel = builder.get_object("mainLabel")
    @extendedLabel = builder.get_object("ExtendedLabel")

    @stack.add(@weatherView)
  end

  def view
    showWeather
    @weatherView
  end

  def showWeather
    if weather = getWeather
      main = weather["weather"].first["main"]
      temp = (weather["main"]["temp"]-273.15).round(1)
      wind  = weather["wind"]["speed"] * 3.6
      humidity = weather["main"]["humidity"]
      image = "images/" + weather["weather"].first["icon"] + ".png"
      @mainImage.set_file(image)
      @mainLabel.set_text("Conditions: #{main}\nTemperature: #{temp}")
      @extendedLabel.set_text("Windspeed: #{wind}\nHumidity: #{humidity}")    
    else
      connectionError
    end
  end

  def sunrise_and_sunset
    weather = getWeather
    sunrise = Time.at(weather["sys"]["sunrise"])
    sunset = Time.at(weather["sys"]["sunset"])
    [sunrise, sunset]
  end

  private

  def connectionError
    @mainLabel.set_text("Connection to weather server failed")
  end

  def getWeather(city = "Mississauga")
    uri = URI.parse("http://api.openweathermap.org/data/2.5/weather?APPID=83658a490b36698e09e779d265859910&q=#{city}")
    begin
      JSON.parse(uri.read)
    rescue
      nil
    end
  end
end
