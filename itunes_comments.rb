#!/Users/pbrocoum/.rvm/rubies/ruby-1.8.7-p330/bin/ruby
require 'rubygems'
require 'appscript'

iTunes = Appscript.app 'iTunes'
file = File.open("/Users/pbrocoum/Desktop/comments.txt", "r")

puts "Enter name of show:"
show = gets.chomp

1.upto(iTunes.current_playlist.tracks.get.size) do |i|
  track = iTunes.current_playlist.tracks[i]
  
  file.gets.chomp
  track.comment.set file.gets.chomp

  # track.season_number.set 0
  # track.episode_number.set 0
  # track.episode_ID.set ''
  # track.show.set show
  # track.video_kind.set :TV_show
  
  puts i.to_s
end
