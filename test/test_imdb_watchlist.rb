require 'minitest/autorun'
require 'imdb_watchlist'

class TestIMDbWatchlist < Minitest::Test
  # Local tests
  def test_parsing_rss_data
    dir = File.dirname(__FILE__)
    file = 'test_rss_data.xml'
    url = File.join(dir, file)
    
    watchlist = IMDbWatchlist.new(url)
    assert_equal watchlist.url, url
    assert_equal watchlist.title, 'WATCHLIST'
    assert_equal watchlist.items.count, 2
    
    assert_equal watchlist.items[0].title, 'Chappie (2015)'
    assert_equal watchlist.items[0].id, 'tt1823672'
    assert_equal watchlist.items[0].url, 'http://www.imdb.com/title/tt1823672/'
    
    assert_equal watchlist.items[1].title, 'Tomorrowland (2015)'
    assert_equal watchlist.items[1].id, 'tt1964418'
    assert_equal watchlist.items[1].url, 'http://www.imdb.com/title/tt1964418/'
  end
  
  # Network tests
  def test_with_rss_url
    url = 'http://rss.imdb.com/user/ur13693513/watchlist'
    watchlist = IMDbWatchlist.new(url)
    assert_equal watchlist.url, url
  end

  def test_with_http_url
    url = 'http://www.imdb.com/user/ur13693513/watchlist'
    watchlist = IMDbWatchlist.new(url)
    assert_equal watchlist.url, url
  end

  def test_with_invalid_imdb_url
    url = 'http://www.imdb.com/user/invaliduserid/watchlist'
    assert_raises(RuntimeError) { IMDbWatchlist.new(url) }
  end

  def test_with_non_imdb_url
    url = 'http://www.example.com'
    assert_raises(RuntimeError) { IMDbWatchlist.new(url) }
  end
end
