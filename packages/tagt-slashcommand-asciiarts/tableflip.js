/*
* Tableflip is a named function that will replace /Tableflip commands
* @param {Object} message - The message object
*/


function Tableflip(command, params, item) {
	if (command === 'tableflip') {
		var msg;

		msg = item;
		msg.msg = params + ' (╯°□°）╯︵ ┻━┻';
		Meteor.call('sendMessage', msg);
	}
}

TAGT.slashCommands.add('tableflip', Tableflip, {
	description: 'Slash_Tableflip_Description',
	params: 'your_message_optional'
});
