'use strict';

var Text = require('../database');

var events = function(io) {

	io.on('connection', function(socket) {

		socket.on('copy_text', function(data) {
			var text = new Text({
				text: data.text,
				date: data.date
			});

			text.save(function(error) {
				if (error) {
					throw error;
				}

				io.emit('copy_text', data);
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
