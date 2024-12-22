Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :income_forecast, path: 'income-forecast', only: [:index] do
    collection do
      post :update_forecasted_income, path: 'update-forecasted-income'
      post :update_conversion_rate, path: 'update-conversion-rate'
    end
  end
end
