class IncomeForecastController < ApplicationController
  before_action :set_conversion_rate
  before_action :set_projected_income, only: %i[create]

  def index; end

  def create
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            'projected_income',
            partial: 'income_forecast/projected_income',
            locals: {
              projected_remaining_income: @projected_remaining_income,
              projected_remaining_income_in_quote_currency: @projected_remaining_income_in_quote_currency
            }
          )
        ]
      end
    end
  end

  def update
    respond_to do |format|
      format.turbo_stream do
        @conversion_rate = CurrencyConversion.conversion_rate(
          base_currency: currency_params[:base_currency],
          quote_currency: currency_params[:quote_currency]
        )

        render turbo_stream: turbo_stream.replace(
          'conversion-rate',
          partial: 'income_forecast/conversion_rate',
          locals: { conversion_rate: @conversion_rate }
        )
      end
    end
  end

  private

  def set_conversion_rate
    # TODO: Setting default currencies for now.
    @base_currency = currency_params[:base_currency] || 'CAD'
    @quote_currency = currency_params[:quote_currency] || 'USD'
    @conversion_rate = CurrencyConversion.conversion_rate(
      base_currency: @base_currency,
      quote_currency: @quote_currency
    )
  end

  def set_projected_income
    return if @conversion_rate.blank?

    @income_calculator = IncomeCalculator.new(
      hours_per_day: form_params[:hours_per_day],
      hourly_rate: form_params[:hourly_rate_dollars],
      conversion_rate: form_params[:conversion_rate],
      business_days: BusinessDaysCalculator.remaining_days_in_year
    )

    @projected_remaining_income = @income_calculator.base_income
    @projected_remaining_income_in_quote_currency = @income_calculator.converted_income
  end

  def currency_params
    params.permit(:base_currency, :quote_currency)
  end

  def form_params
    params.permit(:hours_per_day, :hourly_rate_dollars, :conversion_rate)
  end
end
