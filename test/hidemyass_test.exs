defmodule HidemyassTest do
  use ExUnit.Case, async: true
  doctest Hidemyass

  test "returns a list of free available proxies" do
    proxies = Hidemyass.proxy_list |> IO.inspect
    assert Enum.count(proxies) > 500
  end

  test "finds all free proxy page urls" do
    page_urls = Hidemyass.page_urls
    assert Enum.count(page_urls) == 13
  end

  test "deciphers the ip address from obfuscated table ip cell" do
    ip = Hidemyass.decipher_ip(ip_cell_sample)
    assert ip != nil
  end

  test "scrapes proxy information from a proxy table row" do
    proxy = Hidemyass.scrape_proxy_row(proxy_row_sample)
    assert proxy != nil
  end

  def ip_cell_sample do
    # Result should be: "210.245.27.45"
    """
    <td>
        <span>
          <style>
.AEYB{display:none}
.QWz-{display:inline}
.FF39{display:none}
.ft0U{display:inline}
.lG85{display:none}
.vC_e{display:inline}
</style><span class="lG85">12</span><div style="display:none">12</div><span style="display:none">59</span><span style="display:none">67</span><div style="display:none">67</div><span></span><span style="display:none">178</span><span class="AEYB">178</span><div style="display:none">178</div>210<span style="display:none">213</span><span></span><div style="display:none">236</div><span class="ft0U">.</span><span class="lG85">57</span><span style="display:none">130</span><div style="display:none">130</div><span style="display:none">171</span><span style="display: inline">245</span><span class="56">.</span><span class="QWz-">27</span><span style="display:none">186</span><span class="lG85">186</span><div style="display:none">186</div><span style="display:none">208</span><div style="display:none">208</div><span class="90">.</span><span style="display:none">22</span><span class="FF39">22</span><div style="display:none">22</div>45<span style="display:none">63</span><span class="AEYB">63</span><div style="display:none">63</div><span class="FF39">134</span><div style="display:none">134</div><span style="display:none">235</span><span class="FF39">235</span><span></span>        </span>
    </td>
    """
  end

  def proxy_row_sample do
    """
    <tr class="altshade" style="display: table-row;" rel="30896589"><td class="leftborder timestamp" rel="1472707621"><span class="updatets">1m 8s</span></td><td><span><style>.WstE{display:none}.eZqz{display:inline}.mLky{display:none}.b0uc{display:inline}</style><div style="display:none">73</div>92.<span class="b0uc">222</span><span class="18">.</span><span class="WstE">87</span><div style="display:none">87</div><span style="display: inline">108</span><span class="b0uc">.</span><span style="display: inline">34</span></span></td><td>3128</td><td style="text-align:left" class="country" rel="de"><spanstyle="white-space:nowrap;"><img src="/images/1x1.png" style="width: 16px; height: 11px; margin-right: 5px;" class="flags-de" alt="flag ">Germany</spanstyle="white-space:nowrap;"></td><td><div class="progress-indicator response_time" style="width: 114px" value="3988" levels="speed" rel="3988"><div class="indicator" style="width: 60%; background-color: rgb(255, 204, 0)"></div></div></td><td><div class="progress-indicator connection_time" style="width: 114px" title="" rel="18" value="18" levels="speed"><div class="indicator" style="width: 100%; background-color: rgb(0, 173, 173)"></div></div></td><td>HTTPS</td><td nowrap="">High +KA</td></tr>
    """
  end
end
