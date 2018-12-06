class Transacoes

  attr_accessor :input, :tipo, :coin, :cota, :real, :dolar, :total

  def initialize(input, cota, real, dolar)
    if input.odd?
      @tipo = "compra"
    else
      @tipo = "venda"
    end
    if input < 3
      @coin = "USD"
    else
      @coin = "BRL"
    end
    @cota = cota
    @real = real
    @dolar = dolar
    @total = 0
  end

  def valida(val, coin)
    case coin
      when "USD"
        t = @dolar - val
        if t < 0
          puts "Valor indisponível em #{coin}"
          puts "Valor solicitado: $ #{val}"
          puts "Valor disponível $ #{@dolar}"
          return false
        else
          return true
        end
      when "BRL"
        t = @real - val
        if t < 0
          puts "Valor indisponível em #{coin}"
          puts "Valor solicitado: R$ #{val}"
          puts "Valor disponível R$ #{@real}"
          return false
        else
          return true
        end
    end
  end

  def to_brl(usd)
    val = usd * @cota
  end

  def to_usd(brl)
    val = brl / @cota
  end

  def confirma?()
    puts "Deseja confirmar a transação?"
    puts "[S/n]"
    i = gets.split[0]
    if i == 's' || i == 'S'
      return true
    else
      return false
    end
  end

  def compra_dolar(v_dolar)
    total_r = to_brl(v_dolar)
    @total = v_dolar
    if valida(total_r, "BRL")
      puts "Resumo da compra de USD"
      puts "Valor solicitado em USD: $ #{@total}"
      puts "Valor total em BRL: R$ #{total_r}"
      puts "Cotação: 1 USD = #{@cota} BRL"
      if confirma?()
        @dolar += v_dolar
        @real -= total_r
        arr = [@tipo, @coin, @cota, @total]
      end
    end
  end

  def venda_dolar(v_dolar)
    if valida(v_dolar, "USD")
      total_r = to_brl(v_dolar)
      @total = to_usd(total_r)
      puts "Resumo da venda de USD"
      puts "Valor solicitado em USD: $ #{@total}"
      puts "Valor total em BRL: R$ #{total_r}"
      puts "Cotação: 1 USD = #{@cota} BRL"
      if confirma?()
        @dolar -= v_dolar
        @real += total_r
        arr = [@tipo, @coin, @cota, @total]
      end
    end
  end

  def compra_real(v_real)
    @total = to_usd(v_real)
    if valida(v_real, "BRL")
      puts "Resumo da compra de BRL"
      puts "Valor solicitado em BRL: R$ #{v_real}"
      puts "Valor total em USD: $ #{@total}"
      puts "Cotação: 1 USD = #{@cota} BRL"
      if confirma?()
        @dolar -= @total
        @real += v_real
        arr = [@tipo, @coin, @cota, @total]
      end
    end
  end

  def venda_real(v_real)
    @total = to_usd(v_real)
    if valida(v_real, "USD")
      puts "Resumo da venda de BRL"
      puts "Valor solicitado em BRL: R$ #{v_real}"
      puts "Valor total em USD: $ #{@total}"
      puts "Cotação: 1 USD = #{@cota} BRL"
      if confirma?()
        @real -= v_real
        @dolar += @total
        arr = [@tipo, @coin, @cota, @total]
      end
    end
  end
end
