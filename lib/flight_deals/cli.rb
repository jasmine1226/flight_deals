class FlightDeals::CLI

  def call
    list_deals
    menu
  end

  def list_deals
    puts "Here are the latest flight deals departing from USA:"
  end

  def exit
    puts "Goodbye! Come back for more deals!"
  end

  def menu
    input = nil
    while input != "exit"
      puts "Which deal would you like to learn about? Enter a number or type exit"
      input = gets.strip.downcase
    end
  end

  def deal_info

  end

end
