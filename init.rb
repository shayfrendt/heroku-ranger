module Heroku::Command
  class Ranger < BaseWithApp
    Help.group("Ranger") do |group|
      group.command "ranger",                      "show current app status"
      group.command "ranger:alerts",               "list current alert email addresses"
      group.command "ranger:alerts add <email>",   "add an alert email address"
      group.command "ranger:alerts remove <email>",   "remove an alert email address"
      group.command "ranger:domains",              "list current domains being monitored"
      group.command "ranger:domains add <url>",    "add a domain to be monitored"
      group.command "ranger:domains remove <url>", "remove a domain from being monitored"
      group.command "ranger:domains clear",        "remove all domains from being monitored"
    end

    def index
      puts "App not configured"
    end

    def alerts
      if args.empty?
        # List current email addresses
        puts "Alert email addresses - WIP"
        return
      end

      case args.shift
        when "add"
          email = args.shift
          # Add email address
          puts "Added #{email} as an alert recipient"
          return
        when "remove"
          email = args.shift
          # Remove email address 
          puts "Removed #{email} as an alert recipient"
          return
      end
      raise(CommandFailed, "usage: heroku ranger:alerts <add | remove>")
    end

    def domains
      if args.empty?
        # List out current domains being monitored
        puts "List of domains - WIP"
        domains = heroku.list_domains(app)
        puts "Domains: #{domains}"
        return
      end

      case args.shift
        when "add"
          url = args.shift
          # Monitor the domain
          puts "Added #{url} to the domains being monitored"
          return
        when "remove"
          url = args.shift
          # Stop monitoring the domain
          puts "Removed #{url} from the domains being monitored"
          return
        when "clear"
          # Remove all domains from being monitored
          puts "All domains removed from the monitoring list"
          return
      end
      raise(CommandFailed, "usage: heroku ranger:domains <add | remove | clear>")
    end
  end
end
