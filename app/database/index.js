'use strict';

var Mongoose = require('mongoose');

Mongoose.connect('mongodb://localhost/clippr');
Mongoose.connection.on('error', function(error) {
	if (error) {
		throw error;
	}
});

var TextSchema = new Mongoose.Schema({
	text: {type: String, required: true},
	date: Date
});

TextSchema.pre('save', function(next) {
	var text = this;

	if (!text.date) {
		text.date = new Date();
	}

	next();
});

var Text = Mongoose.model('Text', TextSchema);

module.exports = Text
