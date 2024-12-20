class BusinessDaysCalculator
  def self.remaining_days_in_year
    today = Date.today
    end_of_year = Date.new(today.year, 12, 31)

    (today..end_of_year).count do |date|
      !weekend?(date)
    end
  end

  def self.weekend?(date)
    date.saturday? || date.sunday?
  end
end
