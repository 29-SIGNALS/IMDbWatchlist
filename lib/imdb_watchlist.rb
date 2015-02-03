require 'open-uri'
require 'rss'
require 'uri'

class IMDbWatchlist
  # Load and parse an IMDb watchlist.
  #
  # Example:
  #   url = 'http://www.imdb.com/user/ur13693513/watchlist'
  #   wl = ImdbWatchlist.new(url)
  #   puts wl.to_s
  #   wl.items.each do |item|
  #     puts item.to_s
  #   end
  #
  # Arguments:
  #   url: (String)
  
  @url
  @title
  @items
  
  attr_reader :url
  attr_reader :title
  attr_reader :items
  
  def initialize(url)
    @url = url
    
    open(sanitize_url(url)) do |rss|
      feed = RSS::Parser.parse(rss)
      @title = feed.channel.title
      @items = feed.items.map { |feed_item| Item.new(feed_item) }
    end
  end
  
  def sanitize_url(url)
    uri = URI(url)
    
    # No scheme? Probably a local file path.
    if uri.scheme == nil
      return url
    end

    # Verify host
    if not uri.host.end_with? 'imdb.com'
      raise "Must provide an 'imdb.com' URL '#{url}"
    end
    
    # Verify path
    path_matches = /user\/(ur\d+)\/watchlist/.match(uri.path)
    if not path_matches
      raise "Must provide a watchlist URL '#{url}'"
    end
    
    # Require RSS subdomain
    uri.host = 'rss.imdb.com'
    
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
