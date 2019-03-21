require 'jira-ruby'

class Jira

    def initialize logger, config
        @logger = logger
        @client = JIRA::Client.new({
            auth_type: :basic,
            site: config['site'],
            context_path: '',
            username: config['username'],
            password: config['password'],
        })
    end

    def make_ticket! project
        @logger.info "Creating a JIRA issue for #{project['jira']}"
        issue = @client.Issue.build
        issue.save({
            'fields' => {
                'summary' => 'Composer update nodig',
                'project' => { 'key' => project['jira']},
                'issuetype' => { 'id' => '10102' }, # type BUG
                'customfield_11400' => { 'value' => "Ja" }, # SLA ja/nee
                'labels' => ['backend'],
            },
        })
        @logger.info "Created issue #{issue.key}"
    end
end
