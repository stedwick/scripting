#!/usr/bin/ruby

begin; require 'rubygems'; rescue LoadError; end
require 'appscript'
include Appscript

pgn = `pbpaste`
raise "Not PGN" unless pgn =~ /^1\. /
pgn.gsub!(/\d+\.\s+/, "")
moves = pgn.split(" ")

app('ICC for Mac').activate
sleep 2
moves.each do |move|
	app('System Events').keystroke(move)
	app('System Events').key_code(36)
end
