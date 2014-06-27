require 'mysql2'
require 'yaml'

config = YAML.load_file('/Users/richardthe/hackathon/beer_dashboard/config/database.yml')

SCHEDULER.every '2s' do

  client = Mysql2::Client.new(:host => config['host'], :username => config['username'], :database => config['database'])

  results = client.query("SELECT beer.name AS beer_name, beer.type, location.name AS location_name  FROM beer, location, events  WHERE events.created = (  SELECT MAX( created )  FROM events ) AND beer.upc = events.upc AND location.id = events.location_id LIMIT 1;")

  results = results.map do |row|
    { name: row["beer_name"], body: row["location_name"] }
  end

  client.close

  send_event('lastbeer', { comments: results })#, last: last_most_popular })
  
end
