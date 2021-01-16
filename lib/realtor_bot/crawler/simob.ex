defmodule RealtorBot.Crawler.Simob do
  require Logger
  alias RealtorBot.Crawler.SimobConfig

  @site_configs [
    %SimobConfig{
      id: "habiteto.com.br",
      api_domain: "simob.sa.habiteto.com.br",
      token: "01373e76de01e69c87bbe37872ae63d6",
      category_id: 19
    },
    %SimobConfig{
      id: "piovesanimobiliaria.com.br",
      api_domain: "ipiovesan.simob.com.br",
      token: "0e6ffdd8bca40773aa6abb5f795173af",
      category_id: 2875
    },
    %SimobConfig{
      id: "imobiliariagiusti.com.br",
      api_domain: "simob.com.br",
      token: "f8cf9171be43915263ed8b4b358608fa",
      category_id: nil
    },
    %SimobConfig{
      id: "imobiliariainovar.imb.br",
      api_domain: "imobiliariainovar.simob.com.br",
      token: "b5f0c211405e83ce4f5329d19d3a46ec",
      category_id: 5133
    },
    %SimobConfig{
      id: "investirempreendimentos.com.br",
      api_domain: "simob.com.br",
      token: "caba326ede3fc8ef2a0444316778cc83",
      category_id: 4781
    },
    %SimobConfig{
      id: "imobiliariafacilsmo.com.br",
      api_domain: "simob.com.br",
      token: "ade9126003d71320146a0700b1a62a31",
      category_id: nil
    }
  ]

  def start_crawling() do
    @site_configs
    |> Enum.map(&%{id: &1.id, listings: fetch_site(&1), config: &1})
    |> Enum.map(&to_listing/1)
    |> List.flatten()
    |> Enum.map(&RealtorBot.RealEstate.upsert_listing/1)
  end

  defp to_listing(%{id: id, listings: {:error, error}}) do
    Logger.error("Error fetching listings to #{id}: #{inspect(error)}")
    []
  end

  defp to_listing(%{id: id, listings: {:ok, results}, config: config}) do
    results
    |> Enum.map(
      &%{
        description:
          "#{&1["descricaoCategoria"]} at #{&1["endereco"]}, #{&1["cidade"]}, #{&1["uf"]}",
        agent: id,
        agent_listing_code: &1["codigo"],
        listing_url:
          "https://#{id}/imovel/exibir/venda-lote-urbano-agostini-sao-miguel-do-oeste/#{
            &1["codigo"]
          }",
        image_url: "https://#{config.api_domain}/#{&1["baseUrlImagem"]}/#{&1["imagem"]}"
      }
    )
  end

  defp fetch_site(%SimobConfig{
         id: id,
         api_domain: api_domain,
         token: token,
         category_id: category_id
       }) do
    params = %{
      # Houses
      "idsCategorias" => [category_id],
      # For Rent
      "finalidade" => 1,
      "ceps" => ["SÃO MIGUEL DO OESTE"],
      "idsBairros" => [],
      "rangeValue" => %{"min" => "250.00", "max" => "22000.00"},
      "caracteristicas" => [],
      "offset" => %{"maxResults" => 100, "firstResult" => 0},
      "acuracidade" => 50,
      "countResults" => false,
      "considerarPrevisaoSaida" => false,
      "calcularValorAbono" => false,
      "orderBy" => [
        %{
          "sort" => "valor",
          "descricao" => "Valor",
          "order" => "asc",
          "active" => false,
          "type" => "number"
        },
        %{"sort" => "metrica", "order" => "desc"}
      ],
      "trazerCaracteristicas" => 3
    }

    data = Phoenix.json_library().encode!(params)
    url = "https://#{api_domain}/v2/integracaoApi/imovel/filtro/categoria/caracteristicas"
    payload = Phoenix.json_library().encode!(%{data: data})

    response_data =
      HTTPoison.post(url, payload, [
        {"Authorization", "Bearer #{token}"},
        {"Content-Type", "application/json"},
        {"Origin", "https://#{id}"},
        {"Referer", "https://#{id}/"}
      ])
      |> json_body()

    case response_data["message"] do
      nil -> {:ok, response_data["result"]}
      _ -> {:error, response_data["message"]}
    end
  end

  defp json_body({:ok, %HTTPoison.Response{body: body}}) do
    body
    |> Phoenix.json_library().decode!()
  end

  defp json_body({:error, _}), do: raise("Invalid response body")
end
