json.array!(@tweets) do |tweet|
  json.extract! tweet, :id, :content, :uId
  json.url tweet_url(tweet, format: :json)
end
