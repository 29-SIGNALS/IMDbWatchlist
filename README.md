# IMDb Watchlist

## Description
A simple utility for loading an IMDb user's watchlist.

## Usage
    url = 'http://www.imdb.com/user/ur13693513/watchlist'
    wl = ImdbWatchlist.new(url)
    puts wl.to_s
    wl.items.each do |item|
      puts item.to_s
    end
    
### Result
    
    WATCHLIST - http://rss.imdb.com/user/ur13693513/watchlist - 4 Items
    tt2395427 - Avengers: Age of Ultron (2015) - http://www.imdb.com/title/tt2395427/ - Fri, 07 Nov 2014 16:28:29 -0500
    tt1964418 - Tomorrowland (2015) - http://www.imdb.com/title/tt1964418/ - Thu, 09 Oct 2014 16:11:25 -0400
    tt2562232 - Birdman (2014) - http://www.imdb.com/title/tt2562232/ - Thu, 12 Jun 2014 14:15:42 -0400
    tt0046912 - Dial M for Murder (1954) - http://www.imdb.com/title/tt0046912/ - Fri, 08 Feb 2013 01:07:20 -0500

## License
[MIT](LICENSE.txt)

## Contact
[Brian Partridge](http://brianpartridge.name) - [@brianpartridge](http://twitter.com/brianpartridge)
