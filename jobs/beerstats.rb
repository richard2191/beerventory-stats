require 'mysql2'
require 'yaml'

config = YAML.load_file('/Users/richardthe/hackathon/beer_dashboard/config/database.yml')

# Initialize data points
points = []
(1..10).each do |i|
  points << { x: i, y: 0 }
end
last_x = points.last[:x]

SCHEDULER.every '5s' do

  client = Mysql2::Client.new(:host => config['host'], :username => config['username'], :database => config['database'])

  results = client.query("select count(*) as count from events where created >= NOW() - INTERVAL 5 SECOND;")

  results.each do |row|
    points.shift
    last_x += 1
    points << { x: last_x, y: row["count"].to_i }  
    break
   end

   client.close

  send_event('beerstats', points: points)
end

