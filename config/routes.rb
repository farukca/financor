Financor::Engine.routes.draw do

  resources :invoices do
    resources :involines
  end
  resources :budgetlines

end
