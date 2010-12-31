## Add addon
  heroku addons:add ranger:test
  
## Tell Ranger who to send alerts to
  heroku ranger:alerts add bob@example.com

## Tell Ranger which domain to monitor
  heroku ranger:domains add http://yourapp.heroku.com
