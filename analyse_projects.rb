require 'erb'
require 'json'
require 'tmpdir'

# Read the configuration
projects = JSON.parse(File.read('projects.json'))

results = {}

projects.each do |giturl|

    # Create a temporary directory for us to use
    Dir.mktmpdir do |directory|

        # Clone the project and install dependencies
        `(cd #{directory}; git clone #{giturl} .)`
        `(cd #{directory}; composer install)`

        # Run checks
        composer_outdated = `(cd #{directory}; composer outdated -D --no-ansi)`.lines.count

        # store results
        results[giturl] = {
            composer: composer_outdated,
        }
    end
end

puts results
