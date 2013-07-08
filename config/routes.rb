RedmineApp::Application.routes.draw do
  match 'my/blocks/mywiki/:action', :controller => 'mywiki', :via => [:get, :post]
end
