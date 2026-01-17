# frozen_string_literal: true

module HTB
  module CLI
    class VM < Thor
      def self.exit_on_failure?
        true
      end

      desc "spawn MACHINE_ID", "Spawn a machine (VIP/Starting Point)"
      def spawn(machine_id)
        client = CLI.client
        result = CLI.spinner("Spawning machine #{machine_id}...") do
          client.vm.spawn(machine_id.to_i)
        end

        if result
          if result["success"] == 1 || result["success"] == "1"
            CLI.print_success("Machine is being spawned!")
            CLI.print_info(result["message"]) if result["message"]
          elsif result["message"]
            CLI.print_info(result["message"])
          else
            CLI.print_success("Spawn request sent")
          end
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "terminate MACHINE_ID", "Terminate a running machine"
      def terminate(machine_id)
        client = CLI.client
        result = CLI.spinner("Terminating machine #{machine_id}...") do
          client.vm.terminate(machine_id.to_i)
        end

        if result && (result["success"] == 1 || result["success"] == "1")
          CLI.print_success("Machine terminated!")
        else
          CLI.print_info(result["message"] || "Terminate request sent")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "reset MACHINE_ID", "Reset a machine"
      def reset(machine_id)
        client = CLI.client
        result = CLI.spinner("Resetting machine #{machine_id}...") do
          client.vm.reset(machine_id.to_i)
        end

        if result && (result["success"] == 1 || result["success"] == "1")
          CLI.print_success("Machine reset requested!")
        else
          CLI.print_info(result["message"] || "Reset request sent")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "extend MACHINE_ID", "Extend machine time"
      def extend(machine_id)
        client = CLI.client
        result = CLI.spinner("Extending machine time...") do
          client.vm.extend(machine_id.to_i)
        end

        if result && (result["success"] == 1 || result["success"] == "1")
          CLI.print_success("Machine time extended!")
        else
          CLI.print_info(result["message"] || "Extension request sent")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "status", "Show VM status"
      def status
        client = CLI.client
        data = CLI.spinner("Fetching VM status...") { client.vm.status }

        if data && data["info"]
          info = data["info"]
          puts CLI.pastel.bold("\n=== VM Status ===")
          CLI.print_table(
            ["Field", "Value"],
            [
              ["Machine", info["name"] || "N/A"],
              ["IP", info["ip"] || "N/A"],
              ["Lab", info["lab"] || "N/A"],
              ["Type", info["type"] || "N/A"]
            ]
          )
        else
          CLI.print_info("No active VM")
        end
      rescue HTB::Error => e
        CLI.print_info("No active VM")
      end

      desc "active", "Show active VM"
      def active
        client = CLI.client
        data = CLI.spinner("Fetching active VM...") { client.vm.active }

        if data && data["info"]
          info = data["info"]
          puts CLI.pastel.bold("\n=== Active VM ===")
          CLI.print_table(
            ["Field", "Value"],
            [
              ["Machine", info["name"] || "N/A"],
              ["ID", info["id"] || "N/A"],
              ["IP", CLI.pastel.green(info["ip"]) || "N/A"],
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
    end
  end
end
