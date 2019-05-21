require 'rubygems'
require 'json'
require 'tmpdir'
require 'logger'

require_relative 'src/Analysers/Composer'
require_relative 'src/Jira'
require_relative 'src/ProjectSetup'

# Read the configuration
configuration = JSON.parse(File.read('config.json'))

# Setup classes we need
logger = Logger.new 'results.log'
logger.level = Logger::INFO
jira = Jira.new logger, configuration['jira']
setup = ProjectSetup.new logger, configuration['acf_pro_key']

# Run all projects
logger.info 'Setup completed, starting run'
configuration['projects'].each do |project|
    # Use a temporary directory
    Dir.mktmpdir do |directory|
        Dir.chdir directory do
            setup.install! project
            update_needed = Analysers::Composer.new(logger).analyse
            jira.make_ticket!(project) if update_needed
        end
    end
end
logger.info 'Run completed'
