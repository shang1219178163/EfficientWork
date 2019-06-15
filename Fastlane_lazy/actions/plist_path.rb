module Fastlane
  module Actions
    module SharedValues
      PLIST_PATH_CUSTOM_VALUE = :PLIST_PATH_CUSTOM_VALUE
    end

    class PlistPathAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message "Parameter API Token: #{params[:api_token]}"
        # sh "shellcommand ./path"
        # Actions.lane_context[SharedValues::PLIST_PATH_CUSTOM_VALUE] = "my_val"
        # plistDir = "#{File.dirname(Dir.pwd)}/#{other_action.projectname}"
        plistDir = "#{Dir.pwd}/#{params[:projectname]}"

        puts "plist所在目录：_#{plistDir}_"

        pistPath = Dir.glob("#{plistDir}/*.plist")
        if pistPath.empty? == true
          UI.message "--#{plistDir}不包含.plist文件！！！！--".red
          return ""
        end
        return pistPath.first

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "根据工程名称获取其目录下的默认plist文件路径"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :projectname,
                                       env_name: "PROJECT_NAME", # The name of the environment variable
                                       description: "projectName", # a short description of this parameter
                                       verify_block: proc do |value|
                                          UI.user_error!("No projectName given, pass using `projectname: 'projectname'`") unless (value and not value.empty?)
                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),

        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['PROJECT_NAME', '工程名']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["shang1219178163"]
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end
