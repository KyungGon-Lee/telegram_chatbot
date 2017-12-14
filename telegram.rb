require 'httparty'
require 'awesome_print' # 이쁘게 프린트하는 거 ()젬도깔아야됨)
require 'json' #json
require 'uri'
require 'nokogiri'

url = "https://api.telegram.org/bot"
token = "506056494:AAFOnfw2orgSPIZqqMjngOx-BXQ0UPmBLMA"

response = HTTParty.get("#{url}#{token}/getUpdates")
# ap response.body # ap 붙이면 이쁘게 나옴
hash = JSON.parse(response.body)

chat_id = hash["result"][0]["message"]["from"]["id"]

# KOSPI 지수 스크랩
res = HTTParty.get("http://finance.naver.com/sise/")
html = Nokogiri::HTML(res.body)
kospi = html.css('#KOSPI_now').text

# lotto APU로 로또번호 기쟈오기
res = HTTParty.get("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=784")
lotto =JSON.parse(res.body)

lucky = []

6.times do |n|
lucky << lotto["drwtNo#{n+1}"]
end

bonus = lotto["bnusNo"]
winner = lucky.to_s


# msg = "오늘 코스피 지수는 #{KOSPI_now}"
msg = "오늘 로또 번호는 #{winner} 보너스 번호는 #{bonus}"
encoded = URI.encode(msg)
# msg = "흐에에엥"
ap lucky

# puts kospi


while true
HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
sleep(1) # 1초마다 기다림
end
