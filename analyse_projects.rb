require 'rubygems'
require 'json'
require 'tmpdir'

require_relative 'src/Analysers/Composer'
require_relative 'src/Jira'
require_relative 'src/ProjectSetup'

# Read the configuration
configuration = JSON.parse(File.read('config.json'))

jira = Jira.new(configuration['jira'])
setup = ProjectSetup.new
projects = configuration['projects']

projects.each do |project|

    # Create a temporary directory for us to use
    Dir.mktmpdir do |directory|
        Dir.chdir directory do
            setup.install! project
            update_needed = Analysers::Composer.new.analyse
            jira.make_ticket!(project) if update_needed
        end
    end
end
