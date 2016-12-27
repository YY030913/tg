// TAGT.models._Base.prototype.medalBaseQuery = function(/*userId*/) {
// 	return {};
// };

// TAGT.models._Base.prototype.findMedalsByUserId = function(userId/*, options*/) {
// 	var query = this.medalBaseQuery(userId);
// 	return this.find(query, { fields: { medals: 1 } });
// };

// TAGT.models._Base.prototype.isUserInMedal = function(userId, medalName) {
// 	var query = this.medalBaseQuery(userId);
// 	query.medals = medalName;
// 	return !_.isUndefined(this.findOne(query));
// };

// TAGT.models._Base.prototype.addMedalsByUserId = function(userId, medals) {
// 	medals = [].concat(medals);
// 	console.log("_Base addMedalsByUserId");
// 	var query = this.medalBaseQuery(userId);
// 	console.log(query);
// 	var update = {
// 		$addToSet: {
// 			medals: { $each: medals }
// 		}
// 	};
// 	console.log(update);
// 	return this.update(query, update);
// };

// TAGT.models._Base.prototype.removeMedalsByUserId = function(userId, medals) {
// 	medals = [].concat(medals);
// 	var query = this.medalBaseQuery(userId);
// 	var update = {
// 		$pullAll: {
// 			medals: medals
// 		}
// 	};
// 	return this.update(query, update);
// };

// TAGT.models._Base.prototype.findUsersInMedals = function() {
// 	throw new Meteor.Error('overwrite-function', 'You must overwrite this function in the extended classes');
// };
