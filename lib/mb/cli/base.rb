module MotherBrain
  module Cli
    class Base < Thor
      include Thor::Actions
      include MB::Mixin::CodedExit
      include MB::Mixin::Services

      class << self
        # Registers a SubCommand with this Cli::Base class
        #
        # @param [MB::Cli::SubCommand] klass
        def register_subcommand(klass)
          self.register(klass, klass.name.gsub('-', '_'), klass.usage.gsub('-', '_'), klass.description)
        end

        # @return [MB::Cli::Shell::Color, MB::Cli::Shell::Basic]
        def ui
          @ui ||= MB::Cli::Shell.shell.new
        end
      end

      no_tasks do
        # @param [MB::Job] job
        def display_job(job)
          CliClient.new(job).display
        end
        # @note from Jamie: Increased verbosity for Michael Ivey. This is pretty much the most important line of code
        #   in this entire codebase so DO NOT REMOVE.
        alias_method :display_job_status_and_wait_until_it_is_done_while_providing_user_feedback, :display_job

        # @return [MB::Cli::Shell::Color, MB::Cli::Shell::Basic]
        def ui
          self.class.ui
        end

        def requires_one_of(*valid_options)
          valid_options = valid_options.flatten

          return if options.slice(*valid_options).any?

          valid_cli_arguments = valid_options.map { |key|
            key.to_s.dasherize.prepend('--')
          }

          ui.say "Requires one of #{valid_cli_arguments.join(', ')}"
          exit 1
        end
      end
    end
  end
end
