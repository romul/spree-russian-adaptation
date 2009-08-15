module RussianHelper
  def number_to_currency(number)
    rub = number.to_i
    kop = ((number - rub)*100).round.to_i
    if (kop > 0)
      "#{rub}&nbsp;p.&nbsp;#{'%.2d' % kop}&nbsp;коп."
    else
      "#{rub}&nbsp;p."
    end
  end

  def text_area(object_name, method, options = {})
    begin
      fckeditor_textarea(object_name, method,
        :toolbarSet => 'Easy', :width => '100%', :height => '350px')
    rescue
      super
    end
  end
end

