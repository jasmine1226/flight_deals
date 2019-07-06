class FlightDeals::DealScraper
  attr_accessor :loaded_page

  def self.load_page(url)
    Nokogiri::HTML(open(url))
  end

  def self.scrape_deals(p)
      doc = FlightDeals::DealScraper.load_page("https://www.secretflying.com/usa-deals/page/#{p}/")
      scraped_deals = doc.css("article.category-depart-usa>div.article-content-wrapper")
      scraped_deals.each_with_index do |scraped_deal, i|
        title = scraped_deal.css("h2 a").text
        post_date = scraped_deal.css("div.entry-bottom-details span a time").text
        description = scraped_deal.css("p").text
        url = scraped_deal.css("h2 a").attribute("href").value
        FlightDeals::Deal.create(title, post_date, description, url)
      end
    FlightDeals::Deal.all
  end

  def self.scrape_deal_page(url)
    doc = FlightDeals::DealScraper.load_page(url)
    deal = FlightDeals::Deal.find_by_url(url)
    deal.deal_url = doc.at('a:contains("GO TO DEAL")').attribute("href").value
    info = doc.css("div.entry-content>p")
    info.each_with_index do |p, i|
      item = p.text.split(/[\n:.]/).reject{|c| c.empty?}
      case item[0]
      when "DEPART"
          deal.depart = item[1]
      when "ARRIVE"
          deal.arrive = item[1]
      when "DATES"
          deal.dates = item[1]
      when "STOPS"
          deal.stops = item[1]
      when "AIRLINES"
          deal.airlines = item[1]
      end
    end
    deal
  end

end
