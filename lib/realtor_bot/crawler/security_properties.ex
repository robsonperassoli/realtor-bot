defmodule RealtorBot.Crawler.SecurityProperties do
  @url "https://www.securityimoveis.com.br/imoveis/filtros/?tr=Aluguel&tp=casa&cd=sao-miguel-do-oeste"

  def start_crawling() do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(@url),
         {:ok, document} <- Floki.parse_document(body) do
      Floki.find(document, ".item > a")
      |> Enum.map(&to_listing/1)
      |> Enum.map(&RealtorBot.RealEstate.upsert_listing/1)
    else
      _ -> {:error, "Failed to fetch data from #{@url}"}
    end
  end

  defp to_listing(html_listing) do
    listing_url =
      html_listing
      |> Floki.attribute("href")
      |> List.first()

    name =
      html_listing
      |> Floki.find(".informacoes .nome")
      |> Floki.text()

    location =
      html_listing
      |> Floki.find(".informacoes .info")
      |> Floki.text()

    image_url =
      html_listing
      |> Floki.find("img")
      |> List.first()
      |> Floki.attribute("src")
      |> List.first()

    agent_listing_code =
      listing_url
      |> String.split("/")
      |> Enum.at(4)

    %{
      listing_url: listing_url,
      description: "#{name} at #{location}",
      image_url: image_url,
      agent: "securityimoveis.com.br",
      agent_listing_code: agent_listing_code
    }
  end
end
