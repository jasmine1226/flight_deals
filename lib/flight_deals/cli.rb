class FlightDeals::CLI
  attr_reader :deal

  def call
    list_deals
    menu
  end

  def list_deals
    puts "Here are the latest flight deals departing from USA:"
    @deals = FlightDeals::DealScraper.scrape_deals('https://www.secretflying.com/usa-deals/')
    @deals.each_with_index do |deal, i|
      puts "#{i+1}. #{deal.title} - #{deal.date}"
    end
    puts "Enter a number between 1 to #{@deals.length} to view deal details, 'deals' to view the list of deals, or 'exit'"
    @deals
  end

  def goodbye
    puts "Goodbye! Come back for more deals!"
  end

  def menu
    input = ""
    while input.downcase != "exit"
      puts "What would you like to view?"
      input = gets.strip.downcase
      if input.to_i > 0 && input.to_i < @deals.length
        url = @deals[input.to_i-1].url
        FlightDeals::DealScraper.scrape_deal_page(url)
      elsif input == "deals"
        list_deals
      elsif input == "exit"
        goodbye
      else
        puts "Sorry, I'm not sure what you're looking for..."
        list_deals
      end
    end
  end

end
