# Ruby Clock Radio Project

By Chris Larsen

Ruby v- 2.2.1

This is a simple IoT clock radio. 

Hardware is a Raspberry Pi B+ with a 4.3" touchscreen.

Radio is played through streaming internet radio stations, and controlled with the ruby-mpd gem at https://rubygems.org/gems/ruby-mpd.

The clock is updated through the system clock, and displayed in red with a black background.

GUI is made possible by using the Gtk3 gem at https://rubygems.org/gems/gtk3

# To Do

Must create the display for when playing a radio station. There will be buttons
for playing, stopping and returning to the main screen.

Create an interface between the display and the internet radio stations.
