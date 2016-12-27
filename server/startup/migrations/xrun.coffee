if TAGT.Migrations.getVersion() isnt 0
	TAGT.Migrations.migrateTo 'latest'
else
	control = TAGT.Migrations._getControl()
	control.version = _.last(TAGT.Migrations._list).version
	TAGT.Migrations._setControl control
