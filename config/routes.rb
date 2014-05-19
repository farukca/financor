Financor::Engine.routes.draw do

  resources :invoices do
    resources :involines
    get 'preview', on: :member
  end
  resources :budgetlines

  resources :taxcodes

end
