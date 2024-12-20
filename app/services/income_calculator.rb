class IncomeCalculator
  def initialize(hours_per_day:, hourly_rate:, conversion_rate:, business_days:)
    @hours_per_day = hours_per_day.to_i
    @hourly_rate_cents = (hourly_rate.to_f * 100).to_i
    @conversion_rate = conversion_rate
    @business_days = business_days
  end

  def base_income
    Money.new(@hours_per_day * @hourly_rate_cents * @business_days)
  end

  def converted_income
    base_income / @conversion_rate
  end
end
