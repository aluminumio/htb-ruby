# frozen_string_literal: true

module HTB
  module CLI
    class Main < Thor
      def self.exit_on_failure?
        true
      end

      desc "machines SUBCOMMAND", "Manage machines"
      subcommand "machines", Machines

      desc "vm SUBCOMMAND", "Manage VMs (spawn, terminate, reset)"
      subcommand "vm", VM

      desc "users SUBCOMMAND", "User profiles and info"
      subcommand "users", Users

      desc "challenges SUBCOMMAND", "Manage challenges"
      subcommand "challenges", Challenges

      desc "vpn SUBCOMMAND", "VPN and lab management"
      subcommand "vpn", VPN

      desc "spawn MACHINE_ID", "Spawn a machine (shortcut for vm spawn)"
      def spawn(machine_id)
        invoke "vm:spawn", [machine_id]
      end

      desc "terminate MACHINE_ID", "Terminate a machine (shortcut for vm terminate)"
      def terminate(machine_id)
        invoke "vm:terminate", [machine_id]
      end

      desc "status", "Show current VM and VPN status"
      def status
        client = CLI.client

        puts CLI.pastel.bold("\n=== VM Status ===")
        begin
          vm_status = CLI.spinner("Fetching VM status...") { client.vm.active }
          if vm_status && vm_status["info"]
            info = vm_status["info"]
            CLI.print_table(
              ["Field", "Value"],
              [
                ["Machine", info["name"] || "N/A"],
                ["IP", info["ip"] || "N/A"],
                ["Type", info["type"] || "N/A"],
                ["Expires", info["expires_at"] || "N/A"]
              ]
            )
          else
            CLI.print_info("No active VM")
          end
        rescue HTB::Error => e
          CLI.print_info("No active VM")
        end

        puts CLI.pastel.bold("\n=== VPN Status ===")
        begin
          vpn_status = CLI.spinner("Fetching VPN status...") { client.vpn.status }
          if vpn_status && vpn_status["data"]
            data = vpn_status["data"]
            CLI.print_table(
              ["Field", "Value"],
              [
                ["Connected", data["connection"] ? "Yes" : "No"],
                ["Server", data["server"] || "N/A"],
                ["IP", data["ip"] || "N/A"]
              ]
            )
          else
            CLI.print_info("VPN status unavailable")
          end
        rescue HTB::Error => e
          CLI.print_error(e.message)
        end
      end

      desc "me", "Show current user info"
      def me
        client = CLI.client
        user = CLI.spinner("Fetching profile...") { client.users.me }

        if user && user["info"]
          info = user["info"]
          puts CLI.pastel.bold("\n=== Your Profile ===")
          CLI.print_table(
            ["Field", "Value"],
            [
              ["Username", info["name"] || "N/A"],
              ["ID", info["id"] || "N/A"],
              ["Rank", info["rank"] || "N/A"],
              ["Points", info["points"] || "N/A"],
              ["User Owns", info["user_owns"] || 0],
              ["Root Owns", info["root_owns"] || 0],
              ["Respect", info["respects"] || 0]
            ]
          )
        else
          CLI.print_error("Could not fetch profile")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "version", "Show version"
      def version
        puts "htb #{HTB::VERSION}"
      end

      desc "login", "Configure API token"
      def login
        puts CLI.pastel.bold("HTB Login")
        puts ""
        puts "To get your API token:"
        puts "  1. Go to #{CLI.pastel.cyan(TOKEN_URL)}"
        puts "  2. Scroll down to 'App Tokens'"
        puts "  3. Create a new token or copy an existing one"
        puts ""

        token = CLI.prompt.mask("Paste your API token:")

        if token && !token.strip.empty?
          token = token.strip
          print "Validating token... "
          begin
            test_client = HTB::Client.new(api_token: token)
            user = test_client.users.me
            puts CLI.pastel.green("valid!")

            HTB::Config.api_token = token
            CLI.reset_client!

            puts ""
            CLI.print_success("Token saved to #{HTB::Config.config_file}")

            if user && user["info"]
              puts ""
              puts "Welcome, #{CLI.pastel.bold(user['info']['name'])}!"
              puts "Rank: #{user['info']['rank']}"
            end
          rescue HTB::AuthenticationError
            puts CLI.pastel.red("invalid!")
            CLI.print_error("The token appears to be invalid. Please check and try again.")
            exit 1
          rescue StandardError => e
            puts CLI.pastel.red("error!")
            CLI.print_error("Could not validate token: #{e.message}")
            exit 1
          end
        else
          CLI.print_error("No token provided.")
          exit 1
        end
      end

      desc "logout", "Remove saved API token"
      def logout
        if HTB::Config.api_token
          if CLI.prompt.yes?("Remove saved API token from #{HTB::Config.config_file}?")
            HTB::Config.clear!
            CLI.reset_client!
            CLI.print_success("Logged out. Token removed.")
          else
            CLI.print_info("Cancelled.")
          end
        else
          CLI.print_info("No saved token found.")
        end
      end

      desc "config", "Show current configuration"
      def config
        puts CLI.pastel.bold("\n=== HTB Configuration ===")
        puts ""
        puts "Config file: #{HTB::Config.config_file}"

        if File.exist?(HTB::Config.config_file)
          puts "File exists: #{CLI.pastel.green('Yes')}"
        else
          puts "File exists: #{CLI.pastel.yellow('No')}"
        end

        token = HTB::Config.api_token
        if token
          # Show masked token
          masked = token.length > 20 ? "#{token[0..10]}...#{token[-10..]}" : "***"
          source = ENV["HTB_API_TOKEN"] ? "environment variable" : "config file"
          puts "Token: #{CLI.pastel.green(masked)} (from #{source})"
        else
          puts "Token: #{CLI.pastel.red('Not configured')}"
          puts ""
          puts "Run #{CLI.pastel.cyan('htb login')} to configure."
        end
      end

      map %w[-v --version] => :version
    end
  end
end
