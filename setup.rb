# Author: Chris Larsen

# Setup file for the ruby-radio project. Creates or edits the appropriate
# files to ensure autostart when the Pi boots up.

lines = [["/.xinitrc", "# runs the main program for the ruby radio\n", "ruby ~/workspace/ruby-radio/main.rb\n"],
				 ["/.bashrc", "# initializes x server upon startup\n", "xinit\n"]]

lines.each do |file, comment, line|
	file = File.open(Dir.home + file, "a+")
	file.rewind
	unless file.each_line.to_a.include?(line)
		file.write("\n") unless file.lineno == 0
		file.write(comment)
  	file.write(line)
	end
end

