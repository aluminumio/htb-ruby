# frozen_string_literal: true

require "yaml"
require "fileutils"

module HTB
  class Config
    CONFIG_FILE = File.expand_path("~/.htbrc")

    class << self
      def load
        return {} unless File.exist?(CONFIG_FILE)

        content = File.read(CONFIG_FILE)
        result = YAML.safe_load(content, symbolize_names: true)
        result.is_a?(Hash) ? result : {}
      rescue StandardError
        {}
      end

      def save(config)
        FileUtils.mkdir_p(File.dirname(CONFIG_FILE))
        File.write(CONFIG_FILE, YAML.dump(config.transform_keys(&:to_s)))
        File.chmod(0600, CONFIG_FILE) # Secure permissions
      end

      def api_token
        # Priority: ENV > config file
        ENV["HTB_API_TOKEN"] || load[:api_token]
      end

      def api_token=(token)
        config = load
        config[:api_token] = token
        save(config)
      end

      def configured?
        !api_token.nil? && !api_token.empty?
      end

      def clear!
        File.delete(CONFIG_FILE) if File.exist?(CONFIG_FILE)
      end

      def config_file
        CONFIG_FILE
      end
    end
  end
end
