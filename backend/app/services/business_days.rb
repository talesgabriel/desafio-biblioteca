module BusinessDays
  module_function

  def add(start_date, count)
    date = start_date
    added = 0
    while added < count
      date += 1
      added += 1 unless weekend?(date)
    end
    date
  end

  def weekend?(date)
    date.saturday? || date.sunday?
  end
end
