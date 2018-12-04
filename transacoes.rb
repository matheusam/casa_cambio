class Transacoes

  attr_accessor :cota, :real, :dolar

  def initialize(cota, real, dolar)
    @cota = cota
    @real = real
    @dolar = dolar
    @registro = []
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
    if valida(total_r, "BRL")
      puts "Resumo da compra de USD"
      puts "Valor solicitado em USD: $ #{v_dolar}"
      puts "Valor total em BRL: R$ #{total_r}"
      puts "Cotação: 1 USD = #{@cota} BRL"
      if confirma?()
        @dolar += v_dolar
        @real -= total_r
        salva_operacoes("compra", "USD", @cota, v_dolar)
      end
    end
  end

  def venda_dolar(v_dolar)
    if valida(v_dolar, "USD")
      total_r = to_brl(v_dolar)
      puts "Resumo da venda de USD"
      puts "Valor solicitado em USD: $ #{v_dolar}"
      puts "Valor total em BRL: R$ #{total_r}"
      puts "Cotação: 1 USD = #{@cota} BRL"
      if confirma?()
        @dolar -= v_dolar
        @real += total_r
        salva_operacoes("venda", "USD", @cota, to_usd(total_r))
      end
    end
  end

  def compra_real(v_real)
    total_d = to_usd(v_real)
    if valida(v_real, "BRL")
      puts "Resumo da compra de BRL"
      puts "Valor solicitado em BRL: R$ #{v_real}"
      puts "Valor total em USD: $ #{total_d}"
      puts "Cotação: 1 USD = #{@cota} BRL"
      if confirma?()
        @dolar -= total_d
        @real += v_real
        salva_operacoes("compra", "BRL", @cota, total_d)
      end
    end
  end

  def venda_real(v_real)
    if valida(v_real, "USD")
      total_d = to_usd(v_real)
      puts "Resumo da venda de BRL"
      puts "Valor solicitado em BRL: R$ #{v_real}"
      puts "Valor total em USD: $ #{total_d}"
      puts "Cotação: 1 USD = #{@cota} BRL"
      if confirma?()
        @real -= v_real
        @dolar += total_d
        salva_operacoes("venda", "BRL", @cota, total_d)
      end
    end
  end

  def salva_operacoes(tipo, coin, cot, total)
    serial = {tipo: tipo, coin: coin, cot: cot, total: total}
    @registro << serial
  end

  def mostra_operacoes()
    @registro.each_with_index { | r, index |
      puts "#{index+1} - #{r[:tipo]} - #{r[:coin]} - #{r[:cot]} - #{r[:total]}"
    }
  end

  def balanco()
    report = "Cotação do dia: #{@cota}\nQuantia de reais: R$ #{@real}\nQuantia de dolares: $ #{@dolar}"
    puts report
  end

end
