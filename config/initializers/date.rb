class Date
  EN_MONTHS = I18n.with_locale(:en) {I18n.t('date.abbr_month_names')} 
  RU_MONTHS = I18n.with_locale(:ru) {I18n.t('date.month_names')} 

  MAP_RU_MONTHS = I18n.with_locale(:ru) do
    hash = {}
    I18n.t('date.month_names').each_with_index do |ru_month, i|
      hash[ru_month] = EN_MONTHS[i] 
    end
    hash
  end

  class<< self
    def parse_ru(str)
      str = str.mb_chars
      str.gsub!(/год.*$/, '')
      str.strip!

      str.gsub!(/[а-я]+/) do |ru_month|
        RU_MONTHS.index(ru_month)
      end

      parts = str.split(/\s/)
      parts.map!{|p| p.rjust(2,'0')}
      parts.reverse.join('-')
    end
  end
end
