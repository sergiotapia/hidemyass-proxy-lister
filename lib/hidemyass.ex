defmodule Hidemyass do
  @moduledoc """
  Provides access to the free proxies indexed by HideMyAss.
  """

  @doc """
  Returns a list of all free available proxy lists.
  """
  def proxy_list do
    page_urls
    |> Enum.map(fn(page_url) -> scrape_proxies(page_url) end) 
    |> List.flatten
  end

  @doc """
  Returns a list of all the page urls for indexed proxies.
  """
  def page_urls do
    html_source = download_url("http://proxylist.hidemyass.com/")
    pages = html_source
      |> Floki.find("ul.pagination li a")
      |> Floki.attribute("href")
      |> Enum.map(fn(url) -> "http://proxylist.hidemyass.com" <> url end)

    # Append the page 1 manually.
    pages = ["http://proxylist.hidemyass.com/1" | pages]

    # Remove the duplicate last page, the "next" arrow.
    Enum.slice(pages, 0..-2)
  end

  @doc """
  Returns a list of proxies given a page url.
  """
  def scrape_proxies(page_url) do
    html_source = download_url(page_url)
    
    html_source
    |> Floki.find("table.hma-table tbody tr")
    |> Enum.map(fn(proxy_row) -> scrape_proxy_row(proxy_row) end)
  end

  @doc """
  Returns a struct of proxy information given a proxy html table row.
  """
  def scrape_proxy_row(proxy_row) do
    ip = proxy_row
      |> Floki.find("td")
      |> Enum.at(1)
      |> decipher_ip

    port = proxy_row
      |> Floki.find("td")
      |> Enum.at(2)
      |> Floki.text
      |> String.trim

    country = proxy_row
      |> Floki.find("td")
      |> Enum.at(3)
      |> Floki.text
      |> String.trim

    speed = proxy_row
      |> Floki.find("td")
      |> Enum.at(4)
      |> Floki.find("div")
      |> Floki.attribute("value") 
      |> Enum.at(0) 
      |> String.trim

    connection_time = proxy_row
      |> Floki.find("td")
      |> Enum.at(5)
      |> Floki.find("div")
      |> Floki.attribute("value") 
      |> Enum.at(0) 
      |> String.trim  

    type = proxy_row
      |> Floki.find("td")
      |> Enum.at(6)
      |> Floki.text
      |> String.trim
      
    anonimity = proxy_row
      |> Floki.find("td")
      |> Enum.at(7)
      |> Floki.text 
      |> String.trim   

    %{
      ip: ip,
      port: port,
      country: country,
      speed: speed,
      connection_time: connection_time,
      type: type,
      anonimity: anonimity
    }
  end

  def decipher_ip(ip_cell) do
    styles = ip_cell
      |> Floki.find("span style")
      |> Floki.text
      |> String.split(".")
      |> Enum.map(fn(style) -> "." <> style end)

    styles = Enum.slice(styles, 1..-1)  
      |> Enum.filter(fn(style) -> String.contains?(style, "inline") end)
      |> Enum.join(" ")

    # Iterate through every element and if it's class is in `styles` 
    # it means it's a real IP address.
    {element, attributes, child_nodes} = Floki.find(ip_cell, "span") |> Enum.at(0)

    child_nodes = child_nodes
      |> Enum.slice(1..-1)
      |> Enum.reject(fn(node) -> Floki.text(node) == "" end)
      |> Enum.reject(fn(node) -> !is_bitstring(node) && (Floki.attribute(node, "style") |> Enum.at(0)) == "display:none" end)
    
    child_nodes = child_nodes
      |> Enum.filter(fn(node) -> 
        is_bitstring(node) || class_is_useful(node) || String.contains?(styles, Floki.attribute(node, "class")) || (Floki.attribute(node, "style") |> Enum.at(0)) == "display: inline"
      end)

    child_nodes = child_nodes
      |> Enum.map(fn(node) ->
        if is_bitstring(node) do
          node
        else
          Floki.text(node)
        end
      end)
    
    Enum.join(child_nodes, "")
    |> String.trim 
  end

  def class_is_useful(node) do
    if is_bitstring(node) do
      false
    else
      if (Floki.attribute(node, "class") |> Enum.at(0)) == nil do
        true
      else
        class = (Floki.attribute(node, "class") |> Enum.at(0))
        match = Regex.run ~r/^[0-9]+$/, class
        match != nil  
      end
    end
  end

  defp download_url(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Error: #{url} is 404."
        nil
      {:error, %HTTPoison.Error{reason: _}} ->
        IO.puts "Error: #{url} just ain't workin."
        nil
    end
  end
end
