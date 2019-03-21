class ProjectSetup

    def initialize logger
        @logger = logger
    end

    def install! project
        @logger.info "Cloning project #{project['git']}"
        `(git clone #{project['git']} . 2>&1)`
        `(git checkout master 2>&1)`

        @logger.info "Installing composer dependencies"
        `(composer install 2>&1)`
    end
end
