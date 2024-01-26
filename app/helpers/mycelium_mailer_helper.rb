module MyceliumMailerHelper
  def formatted_inoculation_date(mycelium)
    mycelium.created_at.strftime('%d/%-m/%y %H:%M')
  end
end
