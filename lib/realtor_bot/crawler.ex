defmodule RealtorBot.Crawler do
  require Logger

  # TODO: http://imoveisteia.com.br/pt/pesquisa/real_estate_type:house
  # TODO: imobiliaria stapasson
  # TODO: https://www.imoveisbof.com.br/produto/chacaras-rurais-6/0/cod-065-belissima-chacara-com-casa-65
  # TODO: http://www.imobiliariadavenir.com.br/imoveis/?search-term=1
  # SIMOB

  def start() do
    RealtorBot.Crawler.Simob.start_crawling()

    RealtorBot.Crawler.SecurityProperties.start_crawling()
  end
end
