class FlightDeals::CLI
  attr_reader :current_page, :scraped_page

  def call
    @current_page = 1
    @scraped_page = 1
    FlightDeals::DealScraper.scrape_deals(@scraped_page)
    list_deals(@current_page)
    menu
  end

  def list_deals(page=1)
    puts "Here are the latest flight deals departing from USA:"
    for i in (page-1)*9..page*9-1 do
        puts "#{i+1}. #{FlightDeals::Deal.all[i].title} - #{FlightDeals::Deal.all[i].post_date}"
    end
    puts "Enter a number between #{(page-1)*9+1} to #{page*9} to view deal details;"
    puts "Enter 'deals' to see the deals again;"
    puts "Enter 'next' to the next page;"
    puts "Enter 'back' to the previous page;"
    puts "Or enter 'exit'"
  end

  def next_page
      @current_page += 1
      if @current_page > @scraped_page
        @scraped_page += 1
        FlightDeals::DealScraper.scrape_deals(@scraped_page)
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
      if input.to_i > 0 && input.to_i <= FlightDeals::Deal.all.length
        url = FlightDeals::Deal.all[input.to_i-1].url
        deal = FlightDeals::DealScraper.scrape_deal_page(url)
        deal.display
      elsif input == "deals"
        list_deals(@current_page)
      elsif input == "next"
        next_page
      elsif input == "back"
        prev_page
      elsif input == "exit"
        goodbye
      else
        puts "Sorry, I'm not sure what you're looking for..."
        end
    end
  end
end
