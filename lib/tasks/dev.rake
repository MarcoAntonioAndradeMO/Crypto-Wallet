namespace  :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") { %x(rails db:drop) }
      show_spinner("Criando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD...") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    else
      puts "Você não está no ambiente de desenvolvimento!"
    end
  end

  desc "Cadastra as Moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando Moedas") do
      coins = [
        {
          description: "Bitcoin",
          acronym: "BTC",
          url_image: "https://w7.pngwing.com/pngs/450/133/png-transparent-bitcoin-cryptocurrency-virtual-currency-decal-blockchain-info-bitcoin-text-trademark-logo.png",
          mining_type: MiningType.find_by(acronym: "PoW")
        },
        {
          description: "Etherium",
          acronym: "ETH",
          url_image: "https://w7.pngwing.com/pngs/368/176/png-transparent-ethereum-cryptocurrency-blockchain-bitcoin-logo-bitcoin-angle-triangle-logo.png",
          mining_type: MiningType.all.sample
        },
        {
          description: "Dash",
          acronym: "DASH",
          url_image: "https://seeklogo.com/images/D/dash-logo-4A14989CF5-seeklogo.com.png",
          mining_type: MiningType.all.sample
        },
        {
          description: "Iota",
          acronym: "IOT",
          url_image: "https://w7.pngwing.com/pngs/800/691/png-transparent-iota-crypto-iota-logo-iota-coin-iota-symbol-iota-sign-iota-3d-icon-thumbnail.png",
          mining_type: MiningType.all.sample
        },
        {
          description: "ZCash",
          acronym: "ZEC",
          url_image: "https://png.pngtree.com/png-clipart/20210502/original/pngtree-zcash-crypto-golden-coin-png-image_6270240.jpg",
          mining_type: MiningType.all.sample
        }
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra os tipos de Mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando Minerações") do
      mining_types = [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "Poc"}
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end


  private

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end