class FlightDeals::Deal
  attr_accessor :title, :post_date, :description, :url, :depart, :arrive, :dates, :stops, :airlines

  @@all = []

  def self.create(title, post_date, description, url)
    deal = self.new
    deal.title = title
    deal.post_date = post_date
    deal.description = description
    deal.url = url
    deal.save
    deal
  end

  def self.all
    @@all
  end

  def save
    FlightDeals::Deal.all << self
  end

  def self.find_by_url(url)
    deal = self.all.detect{|deal| deal.url == url}
  end

  def display
    puts "#{self.title} - #{self.post_date}"
    puts "Depart: #{self.depart}" if self.depart
    puts "Arrive: #{self.arrive}" if self.arrive
    puts "Stops: #{self.stops}" if self.stops
    puts "Airlines: #{self.airlines}" if self.airlines
    puts "Availalbe dates: #{self.dates}" if self.dates
  end
end
