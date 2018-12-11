class Main

require "sqlite3"
require_relative 'transactions'
require_relative 'cashier'

COM_DOL = 1
VEN_DOL = 2
COM_REL = 3
VEN_REL = 4
SHOW = 5
CASH_FL = 6
EXIT = 7
CONTINUE = 8

def self.menu(cashier)


  input = CONTINUE
  while input != EXIT
    prompt = "\n[1] Comprar dólares
              \n[2] Vender dólares
              \n[3] Comprar reais
              \n[4] Vender reais
              \n[5] Ver operações do dia
              \n[6] Ver situação do caixa
              \n[7] Sair\n\n"

    puts prompt
    input = gets.split[0].to_i
    system('clear')

    case input
      when COM_DOL
        print "Digite o valor da compra de USD: "
        v_dollar = gets.split[0].to_f
        operation = cashier.buy_dollar(input, v_dollar)
        if operation != nil
          Transactions.save_transactions(operation)
        end
      when VEN_DOL
        print "Digite o valor da venda de USD: "
        v_dollar = gets.split[0].to_f
        operation = cashier.sell_dollar(input, v_dollar)
        if operation != nil
          Transactions.save_transactions(operation)
        end
      when COM_REL
        print "Digite o valor da compra de BRL: "
        total_r = gets.split[0].to_f
        operation = cashier.buy_real(input, total_r)
        if operation != nil
          Transactions.save_transactions(operation)
        end
      when VEN_REL
        print "Digite o valor da venda de BRL: "
        total_r = gets.split[0].to_f
        operation = cashier.sell_real(input, total_r)
        if operation != nil
          Transactions.save_transactions(operation)
        end
      when SHOW
        cashier.show_transactions
      when CASH_FL
        cashier.cash_flow
      when EXIT
        puts "Deseja mesmo sair? [S/n]"
        opt = gets.split[0]
        if opt == 'S' || opt == 's'
          abort("Até mais!")
        else
          input = CONTINUE
        end
	  else
		input = CONTINUE
		puts "opção inválida!\n[ENTER] para continuar..."
		gets
	  end
    end
  end

def self.start()
  system('clear')
  puts "Entre com a cotação atual do dollar: "
  price = gets.split[0].to_f
  puts "Entre com o montante de reais disponíveis: "
  real = gets.split[0].to_f
  puts "Entre com o montante de dólares disponíveis: "
  dollar = gets.split[0].to_f
  system('clear')
  cashier = Cashier.new(price, real, dollar)
  Main.menu(cashier)
end

start()
end
