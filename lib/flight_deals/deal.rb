class FlightDeals::Deal
  attr_accessor :title, :date, :description, :url

  def self.create(title, date, description, url)
    deal = self.new
    deal.title = title
    deal.date = date
    deal.description = description
    deal.url = url
    deal
  end
end
