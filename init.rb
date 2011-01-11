require "heroku"
require "heroku/command"
$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require "ranger/client"
require "heroku/commands/ranger"
