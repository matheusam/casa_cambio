class Transactions
  require "sqlite3"

  attr_accessor :price, :real, :dollar, :total

  def initialize(price, real, dollar)
	  @price = price
    @real = real
    @dollar = dollar
  end

  def to_brl(usd)
    brl = usd * @price
  end

  def to_usd(brl)
    usd = brl / @price
  end

def valid?(val, coin)
    case coin
      when "USD"
        t = @dollar - val
        if t < 0
          puts "Valor indisponível em #{coin}"
          puts "Valor solicitado: $ #{val}"
          puts "Valor disponível $ #{@dollar}"
          return false
        else
          true
        end
      when "BRL"
        t = @real - val
        if t < 0
          puts "Valor indisponível em #{coin}"
          puts "Valor solicitado: R$ #{val}"
          puts "Valor disponível R$ #{@real}"
          return false
        else
          true
        end
    end
  end

  def confirm?(arg)
    if arg[:input].odd?
      type = "compra"
    else
      type = "venda"
    end
    if arg[:input] < 3
      coin = "USD"
	    other_coin = "BRL"
      symbol = "$"
      other_symbol = "R$"
    else
      coin = "USD"
	    other_coin = "BRL"
      symbol = "$"
      other_symbol = "R$"
    end

	   prompt = "\nResumo da #{type} de #{coin}:
              \nValor solicitado em #{coin}: #{symbol} #{arg[:total]}
              \nValor total em #{other_coin}: #{other_symbol} #{arg[:total_r]}
              \nCotação: 1 USD = #{@price} BRL
              \nDeseja confirmar a transação?
              \n[S/n]\n"
    puts prompt
    i = gets.split[0]
    system("clear")
    if i == 's' || i == 'S'
      return true
    else
      false
    end
  end

	def self.load_transactions()
	  register = []
		# #carregar db
    # if File.file?('log.txt') == true
    #   f = File.readlines('log.txt')
    #   f.each_with_index { |line, index|
    #     line = f[index].split(' - ')
    #     serial = {type: line[1], coin: line[2], price: line[3], total: line[4]}
    #     register << serial
    #   }
    #   register
    # else
    #   File.new("log.txt", "w+")
    # end

    #db
    db = SQLite3::Database.new "cambio.db"
    db.execute( "select * from transactions" ) do |row|
      register << row
    end
    db.close
    register


  end

  def self.save_transactions(obj)
    register = load_transactions
    serial = {type: obj[0], coin: obj[1], price: obj[2], total: obj[3]}
    register << serial
    db = SQLite3::Database.new "cambio.db"
    db.execute("INSERT INTO transactions (type, coin, price, total)
    VALUES (?, ?, ?, ?)", [serial[:type], serial[:coin], serial[:price], serial[:total]])
    db.close
  end

end
