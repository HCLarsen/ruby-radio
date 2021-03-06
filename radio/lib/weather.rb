require 'open-uri'
require 'json'
require 'timeout' unless defined?(Timeout)

class Weather
  def initialize(stack)
    @stack = stack

    loadui
    
    @token = ENV['WEATHER_TOKEN']

    #if ENV['WEATHER_TOKEN']
      # load the standard ui
    #else
    #  connectionError
    #end
  end

  def loadui
    ui_file = "#{File.expand_path(__dir__)}/../ui/weather.ui"
    builder = Gtk::Builder.new
    builder.add_from_file(ui_file)

    @weatherView = builder.get_object("weatherView")
    @mainImage = builder.get_object("mainImage")
    @mainLabel = builder.get_object("mainLabel")
    @extendedLabel = builder.get_object("ExtendedLabel")

		@mainLabel.name = "bordered"
		@extendedLabel.name = "bordered"
    @stack.add(@weatherView)
  end

  def view
    showWeather
    @weatherView
  end

  def showWeather
    if @token && weather = getWeather
      main = weather["weather"].first["main"]
      temp = (weather["main"]["temp"]-273.15).round(1)
      windSpeed  = (weather["wind"]["speed"] * 3.6).round(1)
      humidity = weather["main"]["humidity"]
      image = weather["weather"].first["icon"] + ".png"
      imagePath = File.expand_path("../../images/#{image}", __FILE__)
      @mainImage.set_file(imagePath)
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
    if weather = getWeather
      sunrise = Time.at(weather["sys"]["sunrise"])
      sunset = Time.at(weather["sys"]["sunset"])
      [sunrise, sunset]
    end
  end

  private

  def connectionError
    @mainLabel.set_text("Connection to weather server failed")
    @extendedLabel.set_text("No Connection to weather server")
  end

  def getWeather(city = "Mississauga")
    uri = URI.parse("http://api.openweathermap.org/data/2.5/weather?APPID=#{@token}&q=#{URI.escape(city)}")
    begin
      Timeout::timeout(3) do
        JSON.parse(uri.read)
      end
    rescue
      nil
    end
  end
end
