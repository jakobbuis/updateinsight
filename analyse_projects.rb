require 'erb'
require 'json'
require 'tmpdir'

require_relative 'src/Analysers/Composer'

# Read the configuration
projects = JSON.parse(File.read('projects.json'))

results = {}

projects.each do |giturl|

    # Create a temporary directory for us to use
    Dir.mktmpdir do |directory|

        # Clone the project and install dependencies
        `(cd #{directory}; git clone #{giturl} .)`
        `(cd #{directory}; git checkout master)`
        `(cd #{directory}; composer install)`

        # Run checks
        composer = Analysers::Composer.new directory
        result = composer.analyse

        # store results
        results[giturl] = composer.analyse
    end
end

puts results
