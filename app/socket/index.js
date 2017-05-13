'use strict';

var Text = require('../model/text');

var events = function(io) {

	io.on('connection', function(socket) {

		socket.on('copy_text', function(data) {
			var text = new Text({
				text: data.text,
				bundleID: data.bundleID,
				timestamp: data.timestamp
			});

			text.save(function(error) {
				if (error) {
					throw error;
				}

				io.emit('copy_text', text);
			})
		});

		socket.on('history', function(data) {
			Text.find({}, function(error, text) {
				if (error) {
					throw error;
				}

				socket.emit('history', text);
			})
		});
	})
}

var init = function(app) {
	var server = require('http').Server(app);
	var io = require('socket.io')(server);

	events(io);

	return server;
}

module.exports = init;
