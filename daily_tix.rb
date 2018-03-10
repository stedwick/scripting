#!/usr/bin/ruby
require "rubygems"
require "twitter"
require "prowler"
require "active_support/core_ext"

SHOW    = ["Colbert Report", "Daily Show"] #, "Colbert Report"]
NUM_TIX = 4
MONTH   = "May"
DAYS    = [26]

LOG_FILE  = __FILE__ + ".log"
PROWL_API = "910b7bb7022099798d50f9356d07c1ec2e8425d2"

if File.exists?(LOG_FILE)
  if File.mtime(LOG_FILE) < 10.minutes.ago
    File.delete(LOG_FILE)
  else
    log = File.open(LOG_FILE, "r")
    log_text = log.read
    log.close
    if log_text =~ /available/im
      exit
    end
  end
end

log = File.open(LOG_FILE, "w")
log.puts Time.now.to_s

begin

  tweets = Twitter.user_timeline("DailyTix")[0..3]
  for tweet in tweets
    log.puts ""
    time_str = tweet.created_at.strftime("%I:%M")
    log.puts tweet.text + " -- #{time_str}"
    next unless tweet.text =~ /has \d+ tickets/i

    show     = tweet.text.match(/^The (.+?) has/i)[1]
    num_tix  = tweet.text.match(/(\d+) tickets/i)[1].to_i
    month    = tweet.text.match(/for: (.+?) \d+, #{Time.now.year}/i)[1]
    day      = tweet.text.match(/for: .+? (\d+), #{Time.now.year}/i)[1].to_i
    url      = tweet.text.match(/http\S+/)[0]
    log.puts "Show: #{show}, Num Tix: #{num_tix}, Month: #{month}, Day: #{day}, URL: #{url}"

    if tweet.created_at > 10.minutes.ago && month == MONTH && DAYS.include?(day) && SHOW.include?(show) && num_tix >= NUM_TIX
      message = "#{num_tix} #{show} tickets are available for #{month} #{day}! #{url}"
      log.puts message
      `open '#{url}'`
      `say '#{message}'`
      prowler = Prowler.new(:application => "DailyTix", :api_key => PROWL_API)
      prowler.notify show, message, Prowler::Priority::EMERGENCY
      break
    else
      log.puts ":-("
    end
  end

rescue Exception => e
  #
ensure
  log.close
end
