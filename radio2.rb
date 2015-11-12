require 'ruby-mpd'
mpd = MPD.new 'localhost', 6600

mpd.connect

loop do
  print "Type command(on=play, off=stop, +=increase vol, -=decrease vol, exit=quit)"
  command = gets.chomp

  if command == "on"
    mpd.play
  elsif command == "off"
    mpd.stop
  elsif command == "exit"
    exit
  end
end
