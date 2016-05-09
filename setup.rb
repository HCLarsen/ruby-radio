# Author: Chris Larsen

# Setup file for the ruby-radio project. Creates or edits the appropriate
# files to ensure autostart when the Pi boots up.

lines = [["/.xinitrc", "# runs the main program for the ruby radio", "ruby ~/workspace/ruby-radio/main.rb\n"],
         ["/.bashrc", "# initializes x server upon startup", "xinit\n"]]

lines.each do |file, comment, line|
  file = File.open(Dir.home + file, "a+")
  file.rewind
  unless file.each_line.to_a.include?(line)
    file.write(comment)
    file.write(line)
  end
end

