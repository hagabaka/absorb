include Absorb

WebSettings.icon_database_path = 
  File.join(XDG::Cache.home, 'absorb').tap &FileUtils.method(:mkdir_p)

WebView.connect SIGNAL("loadFinished(bool)") do
  Application.top_level_widgets.each do |widget|
    widget.window_icon = WebView.icon
  end
end

