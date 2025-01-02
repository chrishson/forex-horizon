Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  root to: 'income_forecast#index'

  resources :income_forecast, path: 'income-forecast', only: [:index] do
    collection do
      post :update_conversion_rate, path: 'update-conversion-rate'
    end
  end

  namespace :forms do
    resources :income_forecast_form, path: 'income-forecast-form', only: [:index] do
      collection do
        post :update_forecasted_income, path: 'update-forecasted-income'
      end
    end
  end
end
