class FlightDeals::DealScraper

  def self.scrape_deals(url)
    deals = []
    doc = Nokogiri::HTML(open(url))
    scraped_deals = doc.css("article.category-depart-usa>div.article-content-wrapper")
    scraped_deals.each_with_index do |scraped_deal, i|
      title = scraped_deal.css("h2 a").text
      date = scraped_deal.css("div.entry-bottom-details span a time").text
      description = scraped_deal.css("p").text
      url = scraped_deal.css("h2 a").attribute("href").value
      deals << FlightDeals::Deal.create(title, date, description, url)
    end
    deals
  end

  def self.scrape_deal_page(url)
    deal_info = {}

    deal_info
  end

end
