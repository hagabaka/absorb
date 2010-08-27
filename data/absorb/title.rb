include Absorb

WebView.connect SIGNAL('titleChanged(const QString&)') do
  WebView.window_title = WebView.title
end

