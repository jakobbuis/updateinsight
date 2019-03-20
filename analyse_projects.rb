require 'erb'
require 'json'
require 'tmpdir'

require_relative 'src/Analysers/Composer'
require_relative 'src/JIRA'

# Read the configuration
projects = JSON.parse(File.read('projects.json'))

jira = JIRA.new

projects.each do |project|

    # Create a temporary directory for us to use
    Dir.mktmpdir do |directory|
        Dir.chdir directory do
            # Clone the project and install dependencies
            `(git clone #{project.git} .)`
            `(git checkout master)`
            `(composer install)`

            # Run checks
            update_needed = Analysers::Composer.new.analyse

            jira.make_ticket!(project) if update_needed
        end
    end
end
