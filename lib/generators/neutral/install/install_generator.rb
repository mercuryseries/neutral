require 'rails/generators/migration'
require File.expand_path('../../formats', __FILE__)

module Neutral
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include ::Rails::Generators::Migration
      include Neutral::Formats

      source_root File.expand_path("../templates", __FILE__)

      def migrations
        migration_template "votes.rb", "db/migrate/create_neutral_votes"
        migration_template "votings.rb", "db/migrate/create_neutral_votings"
      end

      def routes
        route "neutral"
      end

      def locale
        template "locale.yml", "config/locales/neutral.yml"
      end

      def stylesheet
        if File.binread(css_format[0]).include? "require neutral"
          say_status "skipped", "insert into '#{css_format[0]}'", :yellow
        else
          insert_into_file css_format[0], "\n#{css_format[1]} require neutral\n", after: /require_self/
        end
      end

      def initializer
        template "initializer.rb", "config/initializers/neutral.rb"
      end

      private
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S%6N")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
    end
  end
 end