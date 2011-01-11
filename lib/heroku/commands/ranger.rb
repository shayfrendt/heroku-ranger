module Heroku::Command
  class Ranger < BaseWithApp
    Heroku::Command::Help.group("Ranger") do |group|
      group.command "ranger",                         "show current app status"
      group.command "ranger:domains",                 "list domains being monitored"
      group.command "ranger:domains add <url>",       "start monitoring a domain"
      group.command "ranger:domains remove <url>",    "stop monitoring a domain"
      group.command "ranger:domains clear",           "stop monitoring all domains"
      group.command "ranger:watchers",                "list current app watchers"
      group.command "ranger:watchers add <email>",    "add an app watcher"
      group.command "ranger:watchers remove <email>", "remove an app watcher"
      group.command "ranger:watchers clear",          "remove all app watchers"
    end
    
    def initialize(*args)
      super
    end
    
    def config_vars
      @config_vars ||= heroku.config_vars(app)
    end

    def ranger_client
      ranger_api_url = ENV["RANGER_API_URL"] || config_vars["RANGER_API_URL"]
      ranger_app_id  = ENV["RANGER_APP_ID"]  || config_vars["RANGER_APP_ID"]
      ranger_api_key = ENV["RANGER_API_KEY"] || config_vars["RANGER_API_KEY"]
      abort(" !   Please add the ranger addon first.") unless ranger_api_key
      @ranger_client ||= Ranger::Client.new(ranger_api_url, ranger_app_id, ranger_api_key)
    end

    def index
      dependencies_list
      watchers_list
    end
    
    def dependencies_list
      dependencies = ranger_client.get_dependencies
      
      if dependencies.any?
        puts "\nDomains Being Monitored"
        puts "------------------------------------------"

        dependencies.each do |record|
          url = record[:dependency][:url]
          response_code = record[:dependency][:latest_response_code]
          puts "#{url} #{up_or_down(response_code)}"
        end
        puts ""
      else
        puts "\n---------------------------------------------"
        puts "No domains are being monitored for this app."
        puts "-----------------------------------------------"
        puts "\nMonitor a domain like this:"
        puts "\n  heroku ranger:domains add http://yourapp.heroku.com\n\n"
      end
    end

    def watchers_list
      watchers = ranger_client.get_watchers
      
      if watchers.any?
        puts "\nApp Watchers"
        puts "------------------------------------------"

        watchers.each do |record|
          email = record[:watcher][:email]
          puts "#{email}"
        end
        puts ""
      else
        puts "\n---------------------------------------------"
        puts "No watchers configured to receive app alerts."
        puts "-----------------------------------------------"
        puts "\nConfigure a watcher list this:"
        puts "\n  heroku ranger:watchers add kelly@example.com\n\n"
      end
    end

    def up_or_down(response_code)
      case response_code
      when 200
        "is UP"
      when nil
        "=> not checked yet"
      else
        "is DOWN with status code #{response_code}"
      end
    end

    def create_dependency(url)
      params = { :dependency => { :name => "Website", :url => url, :check_every => "1" }, :api_key => config_vars["RANGER_API_KEY"] }
      ranger_client.create_dependency(params)
      puts "Added #{url} to the monitoring list"
    end

    def create_watcher(email)
      params = { :watcher => { :email => email}, :api_key => config_vars["RANGER_API_KEY"] }
      ranger_client.create_watcher(params)
      puts "Added #{email} as a watcher"
    end

    def domains
      if args.empty?
        domain_list
        return
      end
      
      case args.shift
        when "add"
          url = args.shift
          create_dependency(url)
          return
        when "remove"
          url = args.shift
          ranger_client.delete_dependency_from_url(url)
          puts "Removed #{url} from the monitoring list"
          return
        when "clear"
          ranger_client.clear_all_dependencies
          puts "All domains removed from the monitoring list"
          return
      end
      raise(CommandFailed, "usage: heroku ranger:domains <add | remove | clear>")
    end

    def watchers
      if args.empty?
        watchers_list
        return
      end

      case args.shift
        when "add"
          email = args.shift
          create_watcher(email)
          return
        when "remove"
          email = args.shift
          ranger_client.delete_watcher_from_email(email)
          puts "Removed #{email} as a watcher"
          return
        when "clear"
          ranger_client.clear_all_watchers
          puts "All watchers removed"
          return
      end
      raise(CommandFailed, "usage: heroku ranger:watchers <add | remove | clear>")
    end
  end
end
