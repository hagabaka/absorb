require 'Qt'
require 'redis'

class Absorb::RedisCookieJar < Qt::NetworkCookieJar
  def initialize(*arguments)
    super *arguments
    @redis = Redis.new
    sync_from_redis
  end

  def cookiesForUrl(*arguments)
    sync_from_redis
    super *arguments
  end

  def setCookiesFromUrl(*arguments)
    sync_from_redis
    super *arguments
    sync_to_redis
  end

  private
  def sync_from_redis
    set_all_cookies Qt::NetworkCookie.parseCookies(
                      Qt::ByteArray.new(@redis.get('cookies') || ''))
  end

  def sync_to_redis
    @redis.set('cookies', 
               all_cookies.map {|cookie| cookie.to_raw_form.to_s}.join(', '))
  end
end

page = Absorb::WebView.page
page.network_access_manager.cookie_jar = Absorb::RedisCookieJar.new(page)

