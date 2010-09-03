include Absorb

main_frame = WebView.page.main_frame
main_frame.connect SIGNAL("contentsSizeChanged(const QSize&)") do
  available_size = Application.desktop.available_geometry.size
  MainWindow.size = main_frame.contents_size.bounded_to available_size

  # if after resizing, scrollbars are still displayed, resize again to
  # accomodate for scrollbars
  MainWindow.size = Qt::Size.new do
    [[:Vertical, :width], [:Horizontal, :height]].each do |(orientation, dimension)|
      send :"#{dimension}=",
           MainWindow.size.send(dimension) + 
           main_frame.scroll_bar_geometry(Qt.const_get(orientation)).send(dimension)
    end
  end.bounded_to available_size
end

