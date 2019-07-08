class FlightDeals::DealScraper
  attr_accessor :loaded_page

  def self.load_page(url)
    Nokogiri::HTML(open(url))
  end

  def self.scrape_deals(page)
    doc = FlightDeals::DealScraper.load_page("https://www.secretflying.com/usa-deals/page/#{page}/")
    deals = []
    doc.css("article.category-depart-usa>div.article-content-wrapper").each do |scraped_deal|
      deals << {
      title: scraped_deal.css("h2 a").text,
      post_date: scraped_deal.css("div.entry-bottom-details span a time").text,
      description: scraped_deal.css("p").text,
      url: scraped_deal.css("h2 a").attribute("href").value
      }
    end
    deals
  end

  def self.scrape_deal_page(deal)
    doc = FlightDeals::DealScraper.load_page(deal.url)
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
    deal.scraped = true
    deal
  end

  def self.load_or_scrape_deal(url)
    deal = FlightDeals::Deal.find_by_url(url)
    deal = scrape_deal_page(deal) if deal.scraped == false
    deal
  end
end
