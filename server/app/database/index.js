'use strict';

var Mongoose = require('mongoose');

Mongoose.connect('mongodb://localhost/clippr');

Mongoose.connection.on('error', function(error) {
	if (error) {
		throw error;
	}
});

Mongoose.Promise = global.Promise;

module.exports = Mongoose
