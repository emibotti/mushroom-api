module MyceliumMailerHelper
  def formatted_inoculation_date(mycelium)
    mycelium.inoculation_date.strftime('%d/%-m/%y %H:%M')
  end
end
