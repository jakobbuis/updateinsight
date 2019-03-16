require 'json'

# # Clone the project and install dependencies
`rm -rf temp`
`mkdir temp`
`(cd temp; git clone https://github.com/debolk/bolknoms2.git)`
`(cd temp/bolknoms2; composer install)`
`(cd temp/bolknoms2; npm install)`

# Run checks
composer_outdated = `(cd temp/bolknoms2; composer outdated -D --no-ansi)`

cmd = `(cd temp/bolknoms2; npm outdated --json --depth=0)`
npm_outdated = JSON.parse(cmd)

cmd = `(cd temp/bolknoms2; npm audit --json)`
npm_audits = JSON.parse(cmd)
counts = npm_audits['metadata']['vulnerabilities']
total_issues = counts.values.reduce :+
high_issues = counts['critical'] + counts['high']

# output results
puts "#{composer_outdated.lines.count} composer packages out of date"
puts "#{npm_outdated.count} npm packages out of date"
puts "#{total_issues} known vulnerabilities (#{high_issues} high impact)"


# later:
# - detect yarn or npm usage
# - use temporary directories
# - create jira tickets
