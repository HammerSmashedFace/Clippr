'use strict';

var events = function(io) {
	
	io.on('connection', function(socket) {

		socket.on('text', function(string) {
			socket.send(string);
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
