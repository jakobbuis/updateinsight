require 'json'
require 'tmpdir'

# Read the configuration
projects = JSON.parse(File.read('projects.json'))

projects.each do |name, giturl|

    # Create a temporary directory for us to use
    Dir.mktmpdir do |directory|

        # Clone the project and install dependencies
        `(cd #{directory}; git clone #{giturl} .)`
        `(cd #{directory}; composer install)`
        `(cd #{directory}; npm install)`

        # Run checks
        composer_outdated = `(cd #{directory}; composer outdated -D --no-ansi)`.lines.count

        cmd = `(cd #{directory}; npm outdated --json --depth=0)`
        npm_outdated = JSON.parse(cmd).count

        cmd = `(cd #{directory}; npm audit --json)`
        npm_audits = JSON.parse(cmd)
        counts = npm_audits['metadata']['vulnerabilities']
        total_issues = counts.values.reduce :+
        high_issues = counts['critical'] + counts['high']

        # output results
        puts "Results for #{name}:"
        puts "* #{composer_outdated} composer packages out of date"
        puts "* #{npm_outdated} npm packages out of date"
        puts "* #{total_issues} known vulnerabilities (#{high_issues} high impact)"
    end
end
