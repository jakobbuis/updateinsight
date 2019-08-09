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
        # If a ticket has been created in a previous month, and it is not done yet.
        # We bump its priority instead, and not create a duplicate ticket.
        @logger.info "Checking for an in-progress ticket for #{project['jira']}"
        query = "status != Done AND labels = updateinsight AND Summary ~ \"#{project['github']}\""
        results = @client.Issue.jql(query)
        if results.count > 0
            increase_priority results[0]
        else
            create_new_ticket project
        end
    end

    private

    def increase_priority issue
        current_priority = issue.priority.id.to_i

        # priority IDs go from 5 - Lowest to 1 - Highest
        # we use 2 - High as the max priority for a required update
        new_priority = [2, current_priority - 1].max.to_s

        @logger.info "Increasing the priority of #{issue.key} from #{current_priority} to #{new_priority}"
        begin
            issue.save!({
                'fields' => { 'priority' => { 'id' => new_priority } }
            })
        rescue JIRA::HTTPError => exception
            @logger.error "Cannot increase priority: #{exception.response.body}"
            return
        end
        @logger.info "Increased priority of #{issue.key} to #{new_priority}"
    end

    def create_new_ticket project
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
