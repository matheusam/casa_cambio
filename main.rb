class Main
require_relative 'transacoes'

attr_accessor :controle
  def initialize()
    @controle = nil
  end

  def self.menu()
    input = nil
    while input != 7
      puts "\n\n[1] Comprar dólares"
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
          v_dolar = gets.split[0].to_i
          @controle.compra_dolar(v_dolar)
        when 2
          print "Digite o valor da venda em USD: "
          v_dolar = gets.split[0].to_i
          @controle.venda_dolar(v_dolar)
        when 3
          print "Digite o valor da compra em BRL: "
          v_real = gets.split[0].to_i
          @controle.compra_real(v_real)
        when 4
          print "Digite o valor da venda em BRL: "
          v_real = gets.split[0].to_i
          @controle.venda_real(v_real)
        when 5
          @controle.mostra_operacoes
        when 6
          @controle.balanco
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

  system('clear')
  puts "Entre com a cotação atual do dolar: "
  cota = gets.split[0].to_i
  puts "Entre com o montante de reais disponíveis: "
  real = gets.split[0].to_i
  puts "Entre com o montante de dolares disponíveis: "
  dolar = gets.split[0].to_i
  system('clear')
  @controle = Transacoes.new(cota, real, dolar)
  menu()
end
