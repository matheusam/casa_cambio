class Caixa

  require 'terminal-table/import'
  require_relative 'transacoes'

  attr_accessor :cota, :real, :dolar
  def initialize(cota, real, dolar)
    @cota = cota
    @real = real
    @dolar = dolar
    @registro = []
    if File.file?('log.txt') == true
      f = File.readlines('log.txt')
      f.each_with_index { |linha, index|
        linha = f[index].split(' - ')
        serial = {tipo: linha[1], coin: linha[2], cot: linha[3], total: linha[4]}
        @registro << serial
      }
    else
      File.new("log.txt", "w+")
    end
  #  @controle = nil
  end

  def menu()
    input = nil
    while input != 7
      puts "\n[1] Comprar dólares"
      puts "[2] Vender dólares"
      puts "[3] Comprar reais"
      puts "[4] Vender reais"
      puts "[5] Ver operações do dia"
      puts "[6] Ver situação do caixa"
      puts "[7] Sair\n\n"
      input = gets.split[0].to_i
      system('clear')
      case input
        when 1
          print "Digite o valor da compra em USD: "
          v_dolar = gets.split[0].to_f
          op = Transacoes.new(input, cota, real, dolar)
          obj = op.compra_dolar(v_dolar)
          if obj != nil
            salva_operacoes(obj)
          end
        when 2
          print "Digite o valor da venda em USD: "
          v_dolar = gets.split[0].to_f
          op = Transacoes.new(input, cota, real, dolar)
          obj = op.venda_dolar(v_dolar)
          if obj != nil
            salva_operacoes(obj)
          end
        when 3
          print "Digite o valor da compra em BRL: "
          v_real = gets.split[0].to_f
          op = Transacoes.new(input, cota, real, dolar)
          obj = op.compra_real(v_real)
          if obj != nil
            salva_operacoes(obj)
          end
        when 4
          print "Digite o valor da venda em BRL: "
          v_real = gets.split[0].to_f
          op = Transacoes.new(input, cota, real, dolar)
          obj = op.venda_real(v_real)
          if obj != nil
            salva_operacoes(obj)
          end
        when 5
          self.mostra_operacoes
        when 6
          self.balanco
        when 7
          puts "Deseja mesmo sair? [S/n]"
          escolha = gets.split[0]
          if escolha == 'S' || escolha == 's'
            abort("Até mais!")
          else
            input = nil
          end
      end
    end
  end

  def salva_operacoes(obj)
    serial = {tipo: obj[0], coin: obj[1], cot: obj[2], total: obj[3]}
    @registro << serial
    File.open("log.txt", "w+") do |f|
      @registro.each_with_index { |r, index|
        f.puts "#{index+1} - #{r[:tipo]} - #{r[:coin]} - #{r[:cot]} - #{r[:total]}"
      }
    end
  end

  def mostra_operacoes()
    op = table do |t|
      t.headings = 'Index', 'Tipo', 'Moeda', 'Cotação', 'Total USD'
      @registro.each_with_index { | r, index |
        t << :separator
        t << [index+1, r[:tipo], r[:coin], r[:cot], r[:total]]
      }
    end
    puts op
  end

  def balanco()
    report = table
    report.headings = ["Cotação do dia", "Quantia em BRL: R$", "Quantia em USD: $"]
    report <<  [@cota, @real, @dolar]
    puts report
  end
end

system('clear')
puts "Entre com a cotação atual do dolar: "
cota = gets.split[0].to_f
puts "Entre com o montante de reais disponíveis: "
real = gets.split[0].to_f
puts "Entre com o montante de dolares disponíveis: "
dolar = gets.split[0].to_f
system('clear')
c = Caixa.new(cota, real, dolar)
c.menu()
