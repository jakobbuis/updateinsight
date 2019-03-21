class ProjectSetup

    def install! project
        # Clone the project and install dependencies
        `(git clone #{project['git']} .)`
        `(git checkout master)`
        `(composer install)`
    end
end
