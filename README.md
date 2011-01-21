# Heroku Ranger Plug-in

This is a Heroku plug-in for the Ranger web service. The Ranger Heroku integration is currently in private alpha.

NOTE:  This is spike-quality code.  Check out the __refactor__ if you want to see tests and such.

## Add addon
 
    heroku plugins:install git@github.com:shayfrendt/heroku-ranger.git
    heroku addons:add ranger

## Monitor your domain

    heroku ranger:domains add http://www.example.com
    heroku ranger:watchers add jon-doe@example.com
