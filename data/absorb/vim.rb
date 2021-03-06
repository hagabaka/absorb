require 'Qt'

module Absorb
  # define an action with the given key sequence, name and callback
  def add_action(key, name, &block)
    Qt::Shortcut.new MainWindow do |action|
      action.key = Qt::KeySequence.new key
      action.connect SIGNAL(:activated), &block
    end
  end

  PromptBar = Qt::DockWidget.new do |bar|
    bar.allowed_areas = Qt::BottomDockWidgetArea
    bar.features = Qt::DockWidget::DockWidgetVerticalTitleBar
    bar.visible = false
    PromptBarTitle = bar.title_bar_widget = Qt::Label.new
    PromptBarEdit = bar.widget = Qt::LineEdit.new
  end
  MainWindow.add_dock_widget Qt::BottomDockWidgetArea, PromptBar

  # show the prompt bar, and call the callback when text is entered
  def prompt(label, &block)
    PromptBar.visible = true
    PromptBarTitle.text = label
    PromptBarEdit.set_focus Qt::OtherFocusReason
    PromptBarEdit.connect SIGNAL(:returnPressed) do
      yield PromptBarEdit.text
      hide_prompt
    end
  end

  def hide_prompt
    PromptBarEdit.clear
    PromptBar.visible = false
  end

  def command(string)
    case string
    when /^open (.*)/
      WebView.url = $1
    end
  end

  def focus(widget)
    widget.set_focus Qt::OtherFocusReason
  end

  focus MainWindow
  add_action 'Esc', 'Normal Mode' do
    focus MainWindow
    hide_prompt
  end

  add_action 'i', 'Input Mode' do
    focus WebView
  end

  add_action ':', 'Enter Command' do
    prompt 'Command: ', &method(:command)
  end

  text_to_find = nil
  [ ['/', 'Find', 0],
    ['?', 'Find Backward', Qt::WebPage::FindBackward] ].each do |key, name, flags|
    add_action key, name do
      prompt "#{name}: " do |text|
        text_to_find = text
        WebView.page.find_text text, flags
      end
    end
  end

  [ ['n', 'Find Next', 0],
    ['N', 'Find Previous', Qt::WebPage::FindBackward] ].each do |key, name, flags|
    add_action key, name do
      WebView.page.find_text text_to_find, flags if text_to_find
    end
  end

  add_action 'b', 'Back' do
    WebView.page.history.back
  end

  [ ['k', 'Up',     0, -1],
    ['j', 'Down',   0,  1],
    ['h', 'Left',  -1,  0],
    ['l', 'Right',  1,  0] ].each do |key, name, dx, dy|
    (dx, dy) = [dx, dy].map &20.method(:*)
    add_action key, name do
      WebView.page.main_frame.scroll dx, dy
    end
  end
end

