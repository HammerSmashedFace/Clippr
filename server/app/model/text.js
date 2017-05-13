'use strict';

var Mongoose = require('../database');

var TextSchema = new Mongoose.Schema({
	text: {type: String, required: true},
	bundleID: String,
	timestamp: Number
});

TextSchema.pre('save', function(next) {
	var text = this;

	if (!text.date) {
		text.timestamp = Date.now();
	}

	next();
});

var Text = Mongoose.model('Text', TextSchema);

module.exports = Text;
