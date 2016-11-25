# Ruby Clock Radio Project

By Chris Larsen

Ruby v- 2.1.5

This is a simple IoT clock radio. 

Hardware is a Raspberry Pi B+ with a 2.8" touchscreen.

Radio is played through streaming internet radio stations, and controlled with the ruby-mpd gem at https://rubygems.org/gems/ruby-mpd.

The clock is updated through the system clock.

GUI is made possible by using the Gtk3 gem at https://rubygems.org/gems/gtk3

# Installation Instructions

1. Run apt-get install ruby-dev.
2. Run ruby setup.rb.
3. Add script in .xinitrc to add cronofy token as an environemnt variable.
3. Run bundle install.
4. Reset Raspberry Pi.

# To Do

Improve the styling using CSS. The interface will look much nicer when completed.

Design and 3D print a case for the entire project.

