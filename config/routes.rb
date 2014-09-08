Financor::Engine.routes.draw do

  resources :invoices do
    resources :involines
    get 'preview', on: :member
    get 'estimates', on: :member
  end
  resources :involines
  resources :budgetlines

  resources :taxcodes

end
