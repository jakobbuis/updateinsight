module Analysers
    class Composer

        def initialize dir
            @directory = dir
        end

        def analyse
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
            return (minor.count > 0 || major.count > 0)
        end
    end
end
