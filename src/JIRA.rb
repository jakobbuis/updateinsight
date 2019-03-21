require 'jira-ruby'

class Jira

    def initialize config
        @client = JIRA::Client.new({
            auth_type: :basic,
            site: config['site'],
            context_path: '',
            username: config['username'],
            password: config['password'],
        })
    end

    def make_ticket! project
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
        puts "Created issue for composer updates #{issue.key}"
    end
end
