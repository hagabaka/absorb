require 'kio'

Absorb::WebView.page.network_access_manager.cookie_jar = KIO::Integration::CookieJar.new

