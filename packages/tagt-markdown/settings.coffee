Meteor.startup ->
  TAGT.settings.add 'Markdown_Headers', false, {type: 'boolean', group: 'Message', section: 'Markdown', public: true}
  TAGT.settings.add 'Markdown_SupportSchemesForLink', 'http,https', {type: 'string', group: 'Message', section: 'Markdown', public: true, i18nDescription: 'Markdown_SupportSchemesForLink_Description'}
