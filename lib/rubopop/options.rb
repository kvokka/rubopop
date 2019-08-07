# frozen_string_literal: true

module Rubopop
  # Parse the options from the command line
  class Options
    attr_reader :options, :args

    def initialize(args)
      @args = args
      @options = OpenStruct.new
    end

    def parse
      build_parser.parse!(args)
      options
    end

    private

    def build_parser # rubocop:disable Metrics/MethodLength
      @parser = OptionParser.new do |opts|
        opts.banner = 'Usage: rubopop [options]'

        add_hub_version_option(opts)
        add_rubocop_todo_branch_option(opts)
        add_master_branch_option(opts)
        add_post_checkout_option(opts)
        add_limit_option(opts)
        add_repository_option(opts)
        add_git_origin_option(opts)
        add_on_tail(opts)
      end
    end

    def add_limit_option(opts)
      @options.limit = 10
      msg = "Limit the PS's for one run"
      opts.on('-t [limit]', '--limit [limit]', Integer, msg) do |v|
        @options.limit = v
      end
    end

    def add_post_checkout_option(opts)
      @options.post_checkout = ''
      msg = 'Running after each git checkout (default: "")'
      opts.on('-r [command]', '--post-checkout [command]', String, msg) do |v|
        @options.post_checkout = v
      end
    end

    def add_rubocop_todo_branch_option(opts)
      @options.rubocop_todo_branch = 'rubocop_todo_branch'
      msg = "internal branch with '.rubocop_todo.yml' (default: 'rubocop_todo_branch')"
      opts.on('-b [branch]', '--branch [branch]', String, msg) do |v|
        @options.rubocop_todo_branch = v
      end
    end

    def add_master_branch_option(opts)
      @options.master_branch = 'master'
      msg = "branch which will be the base for all PR's (default: 'master')"
      opts.on('-m [branch]', '--master [branch]', String, msg) do |v|
        @options.master_branch = v
      end
    end

    def add_git_origin_option(opts)
      @options.git_origin = 'origin'
      msg = "origin option for 'git push' (default: 'origin')"
      opts.on('-o [origin]', '--origin [origin]', String, msg) do |v|
        @options.git_origin = v
      end
    end

    def add_hub_version_option(opts)
      @options.hub_version = HUB_VERSION
      msg = "Set manually minimum required version of 'hub' utility for github (default: #{HUB_VERSION})"
      opts.on('-u [version] ', '--hub-version [version]', msg) do |v|
        @options.hub_version = v
      end
    end

    def add_repository_option(opts)
      @options.repository = 'github'
      msg = 'Set repository host (default: github)'
      opts.on('-g [name] ', '--repository [name]', msg) do |v|
        @options.repository = v
      end
    end

    def add_on_tail(opts)
      opts.on_tail('-h', '--help', 'Display help') do
        puts opts
        exit
      end
    end
  end
end
