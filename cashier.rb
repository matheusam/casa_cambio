class Cashier

  require 'terminal-table/import'
  require_relative 'transactions'

  attr_accessor :price, :real, :dollar, :coin, :type, :total, :register
  def initialize(price, real, dollar)
    @price = price
    @real = real
    @dollar = dollar
	  @total = 0
	#retornar array de objetos
	  @register = Transactions.load_transactions
  end
  #done?
  def buy_dollar(input, v_dollar)
    @type = "COMPRA"
    transaction = Transactions.new(@price, @real, @dollar)
    total_r = transaction.to_brl(v_dollar)
    @total = v_dollar
    arg = {total: @total, total_r: total_r, input: input, coin: "USD"}
    if transaction.valid?(arg[:total_r], arg[:coin])
      #nao chama
      if transaction.confirm?(arg)
        @dollar += v_dollar
        @real -= total_r
        arr = [@type, arg[:coin], @price, @total]
      end
    end
  end
#TODO
  def sell_dollar(input, v_dollar)
    @type = "VENDA"
    transaction = Transactions.new(@price, @real, @dollar)
      total_r = transaction.to_brl(v_dollar)
      @total = v_dollar
      arg = {total: @total, total_r: total_r, input: input, coin: "USD"}
      if transaction.valid?(arg[:total], arg[:coin])
        if transaction.confirm?(arg)
          @dollar -= v_dollar
          @real += total_r
        arr = [@type, arg[:coin], @price, @total]
      end
    end
  end

  def buy_real(input, total_r)
    @type = "COMPRA"
    transaction = Transactions.new(@price, @real, @dollar)
    @total = transaction.to_usd(total_r)
    arg = {total: @total, total_r: total_r, input: input, coin: "BRL"}
    if transaction.valid?(arg[:total], arg[:coin])
      if transaction.confirm?(arg)
        @dollar -= @total
        @real += total_r
        arr = [@type, arg[:coin], @price, @total]
      end
    end
  end

  def sell_real(input, total_r)
    @type = "VENDA"
    transaction = Transactions.new(@price, @real, @dollar)
    @total = transaction.to_usd(total_r)
    arg = {total: @total, total_r: total_r, input: input, coin: "BRL"}
    if transaction.valid?(arg[:total], arg[:coin])
      if transaction.confirm?(arg)
        @real -= total_r
        @dollar += @total
        arr = [@type, arg[:coin], @price, @total]
      end
    end
  end

  def show_transactions()
    @register = Transactions.load_transactions
    tab = table do |t|
      t.headings = 'Index', 'Tipo', 'Moeda', 'Cotação', 'Total USD'
      @register.each_with_index { | r, index |
        t << :separator
        t << [index+1, r[1], r[2], r[3], r[4]]
        #error
      }
    end
    puts tab
  end

  def cash_flow()
    report = table
    report.headings = ["Cotação do dia", "Quantia em BRL: R$", "Quantia em USD: $"]
    report <<  [@price, @real, @dollar]
    puts report
  end

end
