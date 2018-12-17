# Ruby Clock Radio Project

By Chris Larsen

Ruby v- 2.3.3

This is a simple IoT clock radio.

Hardware is a Raspberry Pi B+ with a 2.8" touchscreen.

Radio is played through streaming internet radio stations, and controlled with the [ruby-mpd](https://rubygems.org/gems/ruby-mpd) gem.

The clock is updated through the system clock.

GUI is made possible by using the [Gtk3](https://rubygems.org/gems/gtk3) gem

Files for 3D printable casing can be found [here](https://a360.co/2QgYqZv).

NOTE: The weather information is provided by [Open Weather Map](https://openweathermap.org/). To use this feature, you must obtain an OWM API token of you own, and ensure that it's available to the software as an environment variable on your device. The same is true for the alarms feature, which is provided with a [Cronofy](https://www.cronofy.com/) API token. Without these tokens, the rest of the clock will function, but these two features will not be available.

# Installation Instructions

1. Run apt-get install ruby-dev mpd mpc
2. Run ruby setup.rb
3. Add script in .xinitrc to add Cronofy and Open Weather Map tokens as an environemnt variables
3. Run bundle install
4. Reset Raspberry Pi
