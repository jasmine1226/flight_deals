class FlightDeals::Deal
  attr_accessor :scraped,:title, :post_date, :description, :url, :depart, :arrive, :dates, :stops, :airlines, :deal_url

  @@all = {}

  def initialize(deal_hash, page)
    deal_hash.each do |k, v|
      self.send "#{k}=", v
    end
    self.scraped = false
    self.save(page)
  end

  def self.create_from_collection(deals_array, page)
    self.all[page] = []
    deals_array.each do |deal|
      self.new(deal, page)
    end
  end

  def self.all
    @@all
  end

  def save(page)
    FlightDeals::Deal.all[page] << self if FlightDeals::Deal.all[page].include?(self) == false
  end

  def self.find_by_url(url)
    deal = {}
    FlightDeals::Deal.all.each do |page, deals|
        deals.each do |d|
          deal = d if d.url == url
        #deal = deals.detect{|deal| deal.url == url}
        end
    end
    deal
  end

  def display
    puts "#{self.title} - #{self.post_date}"
    puts "Depart: #{self.depart}" if self.depart
    puts "Arrive: #{self.arrive}" if self.arrive
    puts "Stops: #{self.stops}" if self.stops
    puts "Airlines: #{self.airlines}" if self.airlines
    puts "Availalbe dates: #{self.dates}" if self.dates
    puts "Link to deal: #{self.deal_url}" if self.deal_url
  end
end
