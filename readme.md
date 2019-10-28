# UpdateInsight
> Create insight into which projects are potentially out of date and need updates

## Configuration
Copy `config.json.example` to `config.json` and fill in the details as required:

* Some project require a valid key for Advanced Custom Fields Pro to be present before running composer install. This key is colloquially called "ACF_PRO_KEY". If the `acf_pro_key` option is set, the project installation will pre-fill the key for you wherever required.
* `jira` settings should be used to allow communication with the JIRA API
* A project has two required fields in the configuration: `github` which refers to full name of the repository to check, e.g. "IN10/Website-2019"; and `jira` which is the projectcode, i.e. "IN10".
