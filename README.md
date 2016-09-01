# Hidemyass

Easily fetch a list of the free proxy's offered by HideMyAss.

## Installation

Not published on Hex yet.

## How to use

    ```elixir
    proxies = Hidemyass.proxy_list

    [%{anonimity: "High +KA", connection_time: "103", country: "Portugal",
     ip: "88.157.149.250", port: "8080", speed: "5732", type: "HTTPS"},
     %{anonimity: "High +KA", connection_time: "354", country: "Thailand",
     ip: "110.77.159.252", port: "8080", speed: "2929", type: "HTTPS"},
     %{anonimity: "High +KA", connection_time: "3138", country: "Ghana",
     ip: "80.87.81.102", port: "80", speed: "4307", type: "HTTP"},....
    ```

