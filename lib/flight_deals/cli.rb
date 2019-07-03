class FlightDeals::CLI

  def call
    list_deals
    menu
  end

  def list_deals
    deals = FlightDeals::DealScraper.scrape_deals('https://www.secretflying.com/usa-deals/')
    deals.each_with_index do |deal, i|
      puts "#{i+1}. #{deal.title} - #{deal.date}"
    end
    deals
  end

  def exit
    puts "Goodbye! Come back for more deals!"
  end

  def menu
    input = nil
    while input != "exit"
      puts "Here are the latest flight deals departing from USA:"
      self.list_deals
      puts "Which deal would you like to learn about?"
      puts "Enter a number or type exit"
      input = gets.strip.downcase
    end
  end

  def deal_info

  end

end
