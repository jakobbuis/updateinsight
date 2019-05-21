module Analysers
    class Composer

        def initialize logger
            @logger = logger
        end

        def analyse
            @logger.info "Analysing composer dependencies"
            # Parse composer outdated output
            packages = `composer outdated -D --no-ansi`.split("\n").map do |line|
                line.downcase!
                line.scan /^([a-z0-9]+\/[a-z0-9]+) +([0-9a-z\.]+) +([!~=]) +([0-9a-z\.]+)/
            end
            packages.flatten! 1

            # Subdivide into sets based on upgrade path
            minor = packages.select { |p| p[2] === '!' }
            major = packages.select { |p| p[2] === '~' }

            # Create a JIRA-ticket if minor updates are required
            updates = minor.count > 0 || major.count > 0
            @logger.info(updates ? "Composer updates needed" : "Composer updates not needed")
            updates
        end
    end
end
