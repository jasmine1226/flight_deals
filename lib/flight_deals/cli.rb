class FlightDeals::CLI
  attr_reader :current_page, :scraped_page, :region

  def call
    @current_page = 1
    @scraped_page = 1
    @region = self.select_region
    generate_deals(@scraped_page, @region)
    list_deals(@current_page)
    menu
  end

  def generate_deals(page, region)
    deals_array = FlightDeals::DealScraper.scrape_deals(page, region)
    FlightDeals::Deal.create_from_collection(deals_array, page)
  end

  def list_deals(page)
    puts "Here are the latest flight deals:".colorize(:blue)
    puts "<page #{page}>"
    for i in 1..FlightDeals::Deal.all[page].length do
        puts "#{i}. #{FlightDeals::Deal.all[page][i-1].title} - #{FlightDeals::Deal.all[page][i-1].post_date}"
    end
    puts "Enter a number between 1 to #{FlightDeals::Deal.all[page].length} to view deal details;".colorize(:blue)
    puts "Enter" + " 'menu'".colorize(:green) + " to see the deals again;"
    puts "Enter" + " 'next'".colorize(:green) + " to the next page;"
    puts "Enter" + " 'back'".colorize(:green) + " to the previous page;"
    puts "Enter" + " 'region'".colorize(:green) + " to see deals for a differnt region;"
    puts "Or enter" + " 'exit'".colorize(:red)
  end

  def display_deal(deal)
    puts "#{deal.title} - #{deal.post_date}".colorize(:blue)
    puts "Depart:".colorize(:light_blue) + " #{deal.depart}" if deal.depart
    puts "Arrive:".colorize(:light_blue) + " #{deal.arrive}" if deal.arrive
    puts "Stops:".colorize(:light_blue) + " #{deal.stops}" if deal.stops
    puts "Airlines:".colorize(:light_blue) + " #{deal.airlines}" if deal.airlines
    puts "Availalbe dates:".colorize(:light_blue) + " #{deal.dates}" if deal.dates
    puts "Link to deal:".colorize(:light_blue) + " #{deal.deal_url}" if deal.deal_url
  end

  def next_page
      @current_page += 1
      if @current_page > @scraped_page
        @scraped_page += 1
        generate_deals(@scraped_page, @region)
      end
      list_deals(@current_page)
  end

  def prev_page
    @current_page -= 1
    if @current_page < 1
      puts "Sorry, you're at the first page and cannot go back further."
      @current_page = 1
    else
      list_deals(@current_page)
    end
  end

  def goodbye
    puts "Goodbye! Come back for more deals!"
  end

  def menu
    input = ""
    deal = ""
    while input.downcase != "exit"
      puts "What would you like to view?"
      input = gets.strip.downcase
      if input.to_i > 0 && input.to_i <= FlightDeals::Deal.all[@current_page].length
        url = FlightDeals::Deal.all[@current_page][input.to_i-1].url
        deal = FlightDeals::DealScraper.load_or_scrape_deal(url)
        display_deal(deal)
      else
        parse_input(input)
      end
    end
  end

  def parse_input(input)
    case input
    when "menu"
      list_deals(@current_page)
    when "next"
      next_page
    when "back"
      prev_page
    when "region"
      call
    when "exit"
      goodbye
    else
      puts "Sorry, I'm not sure what you're looking for..."
    end
  end

  def select_region
    puts "Where are you departing from?"
    puts "1. USA"
    puts "2. Canada"
    puts "3. Central America & Caribbean"
    puts "4. South America"
    puts "5. Europe"
    puts "6. Middle East & North Africa"
    puts "7. Africa"
    puts "8. Central and South Asia"
    puts "9. East Asia"
    puts "10. Oceania"
    input = gets.strip
    @region = ""
    case input
    when "1"
      @region = "usa"
    when "2"
      @region = "canada"
    when "3"
      @region = "central-america-caribbean"
    when "4"
      @region = "south-america"
    when "5"
      @region = "euro"
    when "6"
      @region = "mena"
    when "7"
      @region = "africa"
    when "8"
      @region = "central-south-asia"
    when "9"
      @region = "east-asia"
    when "10"
      @region = "oceania"
    end
    @region
  end
end
