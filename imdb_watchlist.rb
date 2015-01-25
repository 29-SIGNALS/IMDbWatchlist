require 'open-uri'
require 'rss'
require 'uri'

class ImdbWatchlist
  @url
  @title
  @items
  
  attr_reader :url
  attr_reader :title
  attr_reader :items
  
  def initialize(url)
    @url = url
    
    open(rss_url_for_url(url)) do |rss|
      feed = RSS::Parser.parse(rss)
      @title = feed.channel.title
      @items = feed.items.map { |feed_item| Item.new(feed_item) }
    end
  end
  
  def rss_url_for_url(url)
    uri = URI(url)

    path_matches = /user\/(ur\d+)\/watchlist/.match(uri.path)
    if not path_matches
      raise "Invalid watchlist URL '#{url}'"
    end
    
    rss_host = 'rss.imdb.com'
    if uri.host != rss_host
      uri.host = rss_host
    end
    
    uri.to_s
  end
  
  def to_s
    "#{title} - #{url} - #{items.count} Items"
  end
  
  class Item
    @title
    @id
    @date_added
    @url
    
    attr_reader :title
    attr_reader :id
    attr_reader :date_added
    attr_reader :url
    
    def initialize(rss_item)
      @title = rss_item.title
      @id = URI(rss_item.link).path.split('/').last
      @date_added = rss_item.pubDate
      @url = rss_item.link
    end
    
    def to_s
      "#{id} - #{title} - #{url} - #{date_added}"
    end
  end
end

# Tests

def printWatchlist(url)
  wl = ImdbWatchlist.new(url)
  puts wl.to_s
  wl.items.each do |item|
    puts item.to_s
  end
end

good_urls = ['http://rss.imdb.com/user/ur13693513/watchlist', 'http://www.imdb.com/user/ur13693513/watchlist']
bad_urls = ['http://example.com', 'http://www.imdb.com/user/invaliduserid/watchlist', 'http://www.imdb.com/user/ur13693513/invalidpath']

puts "Good URLs"
good_urls.each { |url| printWatchlist(url) }


puts "Bad URLs"
bad_urls.each do |url| 
  begin 
    printWatchlist(url)
  rescue Exception
    puts "#{url} failed as expected."
  else
    raise "Expected #{url} to fail."
  end
end