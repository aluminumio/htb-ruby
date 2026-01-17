# frozen_string_literal: true

require "thor"
require "tty-table"
require "tty-spinner"
require "tty-prompt"
require "pastel"

require_relative "cli/machines"
require_relative "cli/vm"
require_relative "cli/users"
require_relative "cli/challenges"
require_relative "cli/vpn"
require_relative "cli/main"

module HTB
  module CLI
    TOKEN_URL = "https://app.hackthebox.com/profile/settings"

    class << self
      def pastel
        @pastel ||= Pastel.new
      end

      def prompt
        @prompt ||= TTY::Prompt.new
      end

      def client
        token = HTB::Config.api_token

        unless token
          puts pastel.yellow("No API token configured.")
          puts ""
          puts "To get your API token:"
          puts "  1. Go to #{pastel.cyan(TOKEN_URL)}"
          puts "  2. Scroll down to 'App Tokens'"
          puts "  3. Create a new token or copy an existing one"
          puts ""

          if prompt.yes?("Would you like to enter your API token now?")
            token = prompt.mask("Paste your API token:")

            if token && !token.strip.empty?
              token = token.strip
              # Validate the token by making a test request
              print "Validating token... "
              begin
                test_client = HTB::Client.new(api_token: token)
                test_client.users.me
                puts pastel.green("valid!")

                HTB::Config.api_token = token
                puts pastel.green("Token saved to #{HTB::Config.config_file}")
                puts ""
              rescue HTB::AuthenticationError
                puts pastel.red("invalid!")
                puts pastel.red("The token appears to be invalid. Please check and try again.")
                exit 1
              rescue StandardError => e
                puts pastel.red("error!")
                puts pastel.red("Could not validate token: #{e.message}")
                exit 1
              end
            else
              puts pastel.red("No token provided.")
              exit 1
            end
          else
            puts ""
            puts "You can set your token later with:"
            puts "  #{pastel.cyan('htb login')}"
            puts ""
            puts "Or set the environment variable:"
            puts "  #{pastel.cyan('export HTB_API_TOKEN=your_token')}"
            exit 1
          end
        end

        @client ||= HTB::Client.new(api_token: token)
      end

      def reset_client!
        @client = nil
      end

      def spinner(message)
        spinner = TTY::Spinner.new("[:spinner] #{message}", format: :dots)
        spinner.auto_spin
        result = yield
        spinner.success(pastel.green("done"))
        result
      rescue StandardError => e
        spinner.error(pastel.red("failed"))
        raise e
      end

      def print_table(headers, rows)
        table = TTY::Table.new(header: headers, rows: rows)
        puts table.render(:unicode, padding: [0, 1])
      end

      def print_error(message)
        puts pastel.red("Error: #{message}")
      end

      def print_success(message)
        puts pastel.green(message)
      end

      def print_info(message)
        puts pastel.cyan(message)
      end
    end
  end
end
