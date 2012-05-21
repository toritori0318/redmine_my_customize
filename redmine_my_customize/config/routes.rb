ActionController::Routing::Routes.draw do |map|
  map.connect 'my/blocks/mywiki/:action', :controller => 'mywiki'
end
