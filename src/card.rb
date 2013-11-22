
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
    get_interest on_day, :return_balance => true
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

  def get_interest on_day, return_balance = false
    interest = 0
    balance = 0
    counter = 0
    endd = on_day

    on_day = ( on_day / 30 ).floor * 30
    puts! "on day #{on_day}"

    puts! 'self'
    puts! self

    begin
    while ( self[counter+1] && self[counter+1][:on_day] <= on_day ) || self[counter][:on_day] < on_day

      puts! 'counter'
      puts! counter
      puts! ( self[counter+1] && self[counter+1][:on_day] <= on_day )
      puts! self[counter][:on_day] < on_day

      begin
        endd = self[counter+1][:on_day]
      rescue
        endd = on_day
      end

      puts! "in-loop endd #{endd}"
    
      period = { :begin => self[counter][:on_day], :end => endd }

      puts! 'period'
      puts! period

      balance += self[counter][:amount]
        
      puts! 'balance'
      puts! balance
       
      n_days = period[:end] - period[:begin]
        
      puts! 'n days'
      puts! n_days
        
      this_delta = balance * APR / 365 * n_days 
      interest += this_delta
      
      puts! 'delta'
      puts! this_delta

      counter += 1

    end
    rescue
    end

    if endd < on_day

      balance += self[counter][:amount]
      puts! 'last balance'
      puts! balance 

      n_days = on_day - endd

      puts! 'n_days'
      puts! n_days

      this_delta = balance * APR / 365 * n_days
      interest += this_delta

      puts! 'this delta'
      puts! this_delta
    end

    if return_balance
      return balance.round( 2 )
    else
      return interest.round( 2 )
    end
  end

  def puts! args
    return []
    puts '+++ +++'
    puts args.inspect
  end
  
end

