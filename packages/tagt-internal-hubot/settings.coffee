TAGT.settings.addGroup 'InternalHubot'
TAGT.settings.add 'InternalHubot_Enabled', true, { type: 'boolean', group: 'InternalHubot', i18nLabel: 'Enabled' }
TAGT.settings.add 'InternalHubot_Username', 'Talk Get', { type: 'string', group: 'InternalHubot', i18nLabel: 'Username', i18nDescription: 'InternalHubot_Username_Description' }
TAGT.settings.add 'InternalHubot_ScriptsToLoad', 'hello.coffee,zen.coffee', { type: 'string', group: 'InternalHubot'}
