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
    begin
      redis_watch 'cookies'
      sync_from_redis
    end until redis_multi do
      super *arguments
      sync_to_redis
    end
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

  def redis_watch(*arguments)
    begin
      @redis.watch *arguments
    rescue RuntimeError
    end
  end

  def redis_multi(&block)
    begin
      @redis.multi &block
    rescue RuntimeError
      yield
      true
    end
  end
end

page = Absorb::WebView.page
page.network_access_manager.cookie_jar = Absorb::RedisCookieJar.new(page)

