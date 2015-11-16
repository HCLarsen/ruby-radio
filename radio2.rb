require 'ruby-mpd'
mpd = MPD.new 'localhost', 6600

mpd.connect

station_names = ["Z103.5", "99.9"]

loop do
  print "Type command(on=play, off=stop, +=increase vol, -=decrease vol, exit=quit)"
  command = gets.chomp

  if command == "1"
    mpd.play 0
  elsif command == "2"
    mpd.play 1
  elsif command == "off"
    mpd.stop
  elsif command == "exit"
    exit
  end

  song = mpd.current_song
  puts "Current Station: #{station_names[song.pos]}"
end
