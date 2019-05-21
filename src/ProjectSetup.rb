class ProjectSetup

    def initialize logger, acf_key
        @logger = logger
        @acf_key = acf_key
    end

    def install! project
        @logger.info "Cloning project #{project['github']}"
        `(git clone git@github.com:#{project['github']}.git . 2>&1)`
        `(git checkout master 2>&1)`

        # Check for composer file existence
        if !File.exists?('composer.json')
            @logger.info "Project has no composer.json file, no composer installation performed"
            return
        end

        # Check for the ACF pro key
        if File.readlines('.env.example').grep(/ACF_PRO_KEY=/).size > 0
            @logger.info 'Project uses ACF, pre-filling API key'
            File.write('.env', "ACF_PRO_KEY=#{@acf_key}")
        end

        @logger.info "Installing composer dependencies"
        `(composer install --no-interaction 2>&1)`
    end
end
