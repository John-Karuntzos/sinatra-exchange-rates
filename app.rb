require "sinatra"
require "sinatra/reloader"
require "http"

$currency_list_global = []

get("/") do
  
  api_url = "http://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"

  raw_data = HTTP.get(api_url)

  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)

  currency_hash = parsed_data.fetch("currencies")

  @currency_list = []

  currency_hash.each_key do |key|
    @currency_list.push(key)
  end

  $currency_list_global = @currency_list

  erb(:convert_from)
end

get("/:from") do
  @from = params.fetch("from")
  @currency_list = $currency_list_global
  erb(:convert_to)
end

get("/:from/:to") do
  @from = params.fetch("from")
  @to = params.fetch("to")

  api_url = "http://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}&from=#{@from}&to=#{@to}&amount=1"

  raw_data = HTTP.get(api_url)

  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)

  @result = parsed_data.fetch("result")
  
  erb(:conversion)
end
