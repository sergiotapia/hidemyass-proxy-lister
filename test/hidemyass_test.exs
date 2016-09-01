defmodule HidemyassTest do
  use ExUnit.Case, async: true
  doctest Hidemyass

  test "returns a list of free available proxies" do
    proxies = Hidemyass.proxy_list
    assert Enum.count(proxies) == 625
  end

  test "finds all free proxy page urls" do
    page_urls = Hidemyass.page_urls
    assert Enum.count(page_urls) == 13
  end

  test "scrapes proxy information from a proxy table row" do
    proxy = Hidemyass.scrape_proxy_row(proxy_row_sample)
    assert proxy != nil
  end

  def proxy_row_sample do
    """
    <tr class="altshade" style="display: table-row;" rel="30896589"><td class="leftborder timestamp" rel="1472707621"><span class="updatets">1m 8s</span></td><td><span><style>.WstE{display:none}.eZqz{display:inline}.mLky{display:none}.b0uc{display:inline}</style><div style="display:none">73</div>92.<span class="b0uc">222</span><span class="18">.</span><span class="WstE">87</span><div style="display:none">87</div><span style="display: inline">108</span><span class="b0uc">.</span><span style="display: inline">34</span></span></td><td>3128</td><td style="text-align:left" class="country" rel="de"><spanstyle="white-space:nowrap;"><img src="/images/1x1.png" style="width: 16px; height: 11px; margin-right: 5px;" class="flags-de" alt="flag ">Germany</spanstyle="white-space:nowrap;"></td><td><div class="progress-indicator response_time" style="width: 114px" value="3988" levels="speed" rel="3988"><div class="indicator" style="width: 60%; background-color: rgb(255, 204, 0)"></div></div></td><td><div class="progress-indicator connection_time" style="width: 114px" title="" rel="18" value="18" levels="speed"><div class="indicator" style="width: 100%; background-color: rgb(0, 173, 173)"></div></div></td><td>HTTPS</td><td nowrap="">High +KA</td></tr>
    """
  end
end
