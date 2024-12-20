# app/controllers/income_forecast_controller.rb
class IncomeForecastController < ApplicationController
  before_action :set_currencies
  before_action :set_projected_income, only: %i[index create]

  def index; end

  def create
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'projected_income',
          partial: 'income_forecast/projected_income'
        )
      end
    end
  end

  private

  def set_currencies
    # TODO: Setting default currencies for now.
    @base_currency = currency_params[:base_currency] || 'CAD'
    @quote_currency = currency_params[:quote_currency] || 'USD'
    @currency_service = CurrencyService.new(base_currency: @base_currency,
                                            quote_currency: @quote_currency)
    @conversion_rate = @currency_service.conversion_rate
  end

  def set_projected_income
    @income_calculator = IncomeCalculator.new(
      hours_per_day: income_params[:hours_per_day],
      hourly_rate: income_params[:hourly_rate_dollars],
      conversion_rate: @conversion_rate,
      business_days: BusinessDaysCalculator.remaining_days_in_year
    )

    @projected_remaining_income = @income_calculator.base_income
    @projected_remaining_income_in_quote_currency = @income_calculator.converted_income
  end

  def currency_params
    params.permit(:base_currency, :quote_currency)
  end

  def income_params
    params.permit(:hours_per_day, :hourly_rate_dollars)
  end
end
