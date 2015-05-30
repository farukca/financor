Financor::Engine.routes.draw do

  resources :finpoints
  resources :finitems

  resources :invoices do
    resources :involines
    get 'preview', on: :member
    get 'estimates', on: :member
  end
  resources :involines
  resources :budgetlines
  resources :accounts

  resources :taxcodes
  resources :currency_rates
  get 'find_rate', to: 'currency_rates#find_rate'
  
end
