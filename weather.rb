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
      windSpeed  = (weather["wind"]["speed"] * 3.6).round(1)
      humidity = weather["main"]["humidity"]
      image = "images/" + weather["weather"].first["icon"] + ".png"
      @mainImage.set_file(image)
      @mainLabel.set_text("Conditions: #{main}\nTemperature: #{temp}oC")
      if windSpeed > 5 && temp < 10
        windChill = (13.12 + 0.6215 * temp - 11.37 * windSpeed ** 0.16 + 0.3965 * temp * windSpeed ** 0.16).round(1)
        @extendedLabel.set_text("Wind Speed: #{windSpeed}km/h\tWindchill: #{windChill}oC\nHumidity: #{humidity}%")
      else
        @extendedLabel.set_text("Wind Speed: #{windSpeed}km/h\nHumidity: #{humidity}%")
      end
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
    uri = URI.parse("http://api.openweathermap.org/data/2.5/weather?APPID=83658a490b36698e09e779d265859910&q=#{URI.escape(city)}")
    begin
      JSON.parse(uri.read)
    rescue
      nil
    end
  end
end
