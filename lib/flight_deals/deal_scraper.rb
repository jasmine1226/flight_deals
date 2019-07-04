class FlightDeals::DealScraper

  def self.scrape_deals(url)
    deals = []
    doc = Nokogiri::HTML(open(url))
    scraped_deals = doc.css("article.category-depart-usa>div.article-content-wrapper")
    scraped_deals.each_with_index do |scraped_deal, i|
      title = scraped_deal.css("h2 a").text
      post_date = scraped_deal.css("div.entry-bottom-details span a time").text
      description = scraped_deal.css("p").text
      url = scraped_deal.css("h2 a").attribute("href").value
      deals << FlightDeals::Deal.create(title, post_date, description, url)
    end
    deals
  end

  def self.scrape_deal_page(url)
    doc = Nokogiri::HTML(open(url))
    deal = FlightDeals::Deal.find_by_url(url)
    deal.depart = doc.at('strong:contains("DEPART:")').next_element.next_element.text
    deal.arrive = doc.at('strong:contains("ARRIVE:")').next_element.next_element.text
    deal.dates = doc.at('strong:contains("DATES:")').next_element.next_element.text
    deal.stops = doc.css("div.snews-cat a")[0].text
    deal.airlines = doc.at('strong:contains("AIRLINES:")').next_element.next_element.text
    deal
  end

end
