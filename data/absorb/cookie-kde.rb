require 'kio'

# This cookie jar uses DBus to talk to the KDE cookie jar service. Based on
# kio/khtml/accessmanager.cpp
# http://api.kde.org/4.x-api/kdelibs-apidocs/kio/html/accessmanager_8cpp_source.html
class Absorb::KDECookieJar < Qt::NetworkCookieJar
  KCOOKIEJAR_DBUS = Qt::DBusInterface.new 'org.kde.kded', '/modules/kcookiejar',
                                          'org.kde.KCookieServer'
  WINDOW_ID = WebView.win_id

  def cookiesForUrl(url)
    kcookiejar('findDOMCookies', url.to_string).
      split('; ').reject(&:empty?).map do |cookie|
        Qt::NetworkCookie.new *cookie.split('=', 2).map(&Qt::ByteArray.method(:new))
      end
  end

  def setCookiesFromUrl(cookies, url)
    cookies.each do |cookie|
      kcookiejar 'addCookies',
                 url.to_string, 
                 cookie.to_raw_form(Qt::NetworkCookie::Full), 
                 Qt::Variant.from_value(WINDOW_ID, 'long')
    end
  end

  def kcookiejar(method, *arguments)
    reply = Qt::DBusReply.new KCOOKIEJAR_DBUS.call(method, *arguments)
    unless reply.valid?
      $stderr.puts reply.error.message
    end
    reply.value
  end
end

page = Absorb::WebView.page
page.network_access_manager.cookie_jar = Absorb::KDECookieJar.new(page)

