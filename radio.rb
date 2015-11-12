require 'mpd_client'

client = MPDClient.new

client.connect('localhost', 6600)

loop do
  print "Type command(on=play, off=stop, +=increase vol, -=decrease vol, exit=quit)"
  command = gets.chomp

  if command == "on"
    client.play
  elsif command == "off"
    client.stop
  elsif command == "exit"
    exit
  end
end
