module Analysers
    class Composer

        def initialize logger
            @logger = logger
        end

        def analyse
            # Check for composer file existence
            if !File.exists?('composer.json')
                @logger.info "Project has no composer.json file, no composer analysis performed"
                return false
            end

            # Run composer analysis
            @logger.info "Analysing composer dependencies"
            command = `composer outdated -oDm --strict -f=json`
            packages = JSON.parse(command)

            # Create a JIRA-ticket if minor updates are required
            update_needed = packages.installed.count > 0
            @logger.info(update_needed ? "Composer updates needed" : "Composer updates not needed")
            update_needed
        end
    end
end
