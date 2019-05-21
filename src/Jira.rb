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
        begin
            issue.save!({
                'fields' => {
                    'summary' => "Composer update nodig voor #{project['github']}",
                    'project' => { 'key' => project['jira']},
                    'issuetype' => { 'id' => '10102' }, # type BUG
                    'customfield_11400' => { 'value' => "Ja" }, # SLA ja/nee
                    'labels' => ['backend', 'updateinsight'],
                },
            })
        rescue JIRA::HTTPError => exception
            @logger.error "Cannot create issue in JIRA: #{exception.response.body}"
            return
        end
        @logger.info "Created issue #{issue.key}"
    end
end
