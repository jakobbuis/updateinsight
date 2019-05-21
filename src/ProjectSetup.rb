class ProjectSetup

    def initialize logger
        @logger = logger
    end

    def install! project
        @logger.info "Cloning project #{project['github']}"
        `(git clone git@github.com:#{project['github']}.git . 2>&1)`
        `(git checkout master 2>&1)`

        @logger.info "Installing composer dependencies"
        `(composer install --no-interaction 2>&1)`
    end
end
