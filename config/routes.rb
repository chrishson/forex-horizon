Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'income-forecast' => 'income_forecast#index', as: :income_forecast

  namespace :forms do
    resources :income_forecast_form, path: 'income-forecast-form', only: [:index] do
      collection do
        post :update_forecasted_income, path: 'update-forecasted-income'
      end
    end
    resources :currency_conversion_form, path: 'currency-conversion-form', only: [:index] do
      collection do
        post :update_conversion_rate, path: 'update-conversion-rate'
      end
    end
  end
end
