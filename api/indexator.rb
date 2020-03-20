require 'date'
require 'net/http'
require 'json'

class Indexator
  attr_reader :contract_signature_date, :contract_start_date, :base_rent
  BASE_POSSIBLE_YEARS = [1988, 1996, 2004, 2013].freeze

  def initialize(contract_signature_date, contract_start_date, base_rent)
    @contract_signature_date = contract_signature_date
    @contract_start_date = contract_start_date
    @base_rent = base_rent.to_i
  end

  def new_rent
    base = define_base
    base_month = define_base_month
    current_month = self.current_month
    base_index = self.base_index(base, base_month).to_f
    current_index = self.current_index(base, current_month).to_f
    (@base_rent * current_index / base_index).round(2)
  end

  def define_base
    year_of_contract_signature = @contract_signature_date[0..3].to_i
    BASE_POSSIBLE_YEARS.select { |x| year_of_contract_signature >= x }.max
  end

  def month_before
    x = (@contract_signature_date[5..6].to_i - 1).to_s
    if x == '0'
      '12'
    elsif x.to_i >= 1 && x.to_i < 9
      '0' + x
    elsif x.to_i >= 10 && x.to_i < 12
      x.to_s
    else
      '0' + x
    end
  end

  def define_base_month
    if month_before == '12'
      year = (@contract_signature_date[0..3].to_i - 1).to_s
    else
      year = @contract_signature_date[0..3]
    end
    year + '-' + month_before
  end

  def current_month
    current_year = Date.today.to_s[0..3].to_i
    year_contract_signature = @contract_start_date[0..3].to_i
    if current_year == year_contract_signature
      if month_before == '12'
        year = (contract_start_date[0..3].to_i - 1).to_s
      else
        year = @contract_start_date[0..3]
      end
      year + '-' + month_before
    else
      (current_year - 1).to_s + '-' + month_before
    end
  end

  def base_index(base, base_month)
    url = "https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/indexes/#{base}/#{base_month}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)['index']['MS_HLTH_IDX']
  end

  def current_index(base, current_month)
    url2 = "https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/indexes/#{base}/#{current_month}"
    uri2 = URI(url2)
    response2 = Net::HTTP.get(uri2)
    JSON.parse(response2)['index']['MS_HLTH_IDX']
  end
end
