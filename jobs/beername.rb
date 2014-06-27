require 'mysql2'
require 'yaml'

config = YAML.load_file('/Users/richardthe/hackathon/beer_dashboard/config/database.yml')

SCHEDULER.every '2s' do

  client = Mysql2::Client.new(:host => config['host'], :username => config['username'], :database => config['database'])

  results = client.query("select derived.count, beer.name, beer.type from beer, (SELECT COUNT(*) AS count, upc FROM events GROUP BY upc) as derived where beer.upc = derived.upc order by derived.count desc limit 1;")

  results = results.map do |row|
    { name: row["name"], body: row["type"] }
  end

  client.close

  send_event('beername', { comments: results })#, last: last_most_popular })
  
end
