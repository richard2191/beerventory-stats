require 'mysql2'
require 'yaml'

config = YAML.load_file('/Users/richardthe/hackathon/beer_dashboard/config/database.yml')

buzzwords = [] 
buzzword_counts = Hash.new({ value: 0 })

SCHEDULER.every '2s' do

  client = Mysql2::Client.new(:host => config['host'], :username => config['username'], :database => config['database'])

  results = client.query("select name, qty from beer")

  results.each do |row|
    buzzword_counts[row["name"]] = { label: row["name"], value: row["qty"]}
  end

  client.close
  
  send_event('beerlist', { items: buzzword_counts.values })
end