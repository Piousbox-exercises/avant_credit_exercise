
class Card < Array

  def apr
    APR
  end

  def limit
    LIMIT
  end

  def draw i
    raise "amount must be positive" if i[:amount] <= 0
    add_transaction :on_day => i[:on_day], :amount => i[:amount]
  end

  def make_payment i
    raise "amount must be positive" if i[:amount] <= 0
    add_transaction :on_day => i[:on_day], :amount => -i[:amount]    
  end

  def get_balance on_day
    interest = 0
    balance = 0
    counter = 0

    this_day = ( on_day / 30 ).floor * 30

    begin
      endd = self[counter+1][:on_day]
    rescue
      endd = this_day
    end

    period = { :begin => self[counter][:on_day], :end => endd }
    if period[:end] >= this_day
      balance += self[0][:amount]
      n_days = period[:end] - period[:begin]
      this_delta = balance * APR / 365 * n_days 
      interest += this_delta
    end

    # puts! 'balance'
    # puts! balance

    return balance
  end


  def payoff_amount i
    on_day = i[:on_day]
    return get_interest( on_day ) + get_balance( on_day )
  end

  def interest i
    get_interest i[:on_day]
  end

  #
  #
  #
  private

  APR = 0.35
  LIMIT = 1000

  def add_transaction i
    raise ":on_day must be a positive integer" if i[:on_day] < 1
    self << i
    self.sort_by! { |k| k[:on_day] }
  end

  def get_interest on_day
    # puts! 'on day'
    # puts! on_day

    interest = 0
    balance = 0
    counter = 0

    this_day = ( on_day / 30 ).floor * 30

    # puts! 'this day:'
    # puts! this_day

    begin
      endd = self[counter+1][:on_day]
    rescue
      endd = this_day
    end

    # puts! endd
    
    period = { :begin => self[counter][:on_day], :end => endd }
    if period[:end] >= this_day
      balance += self[0][:amount]

      # puts! 'balance'
      # puts! balance

      # puts! period

      n_days = period[:end] - period[:begin]
     
      # puts! 'n days'
      # puts! n_days

      this_delta = balance * APR / 365 * n_days 
      interest += this_delta
      # puts! 'delta'
      # puts! this_delta
    end

    # puts! interest
    return interest.round( 2 )
  end

  def puts! args
    puts '+++ +++'
    puts args.inspect
  end

  class Transaction < Hash    
    def initialize
    end
  end
  
end

