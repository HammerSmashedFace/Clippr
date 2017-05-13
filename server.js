'use strict';

var app = require('express')();
var server = require('http').Server(app);
var socket = require('socket.io')(server);
var bodyParser = require('body-parser');

var port = process.env.PORT || 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', function(request, responce) {
	responce.send("Hello world");
});

server.listen(port, function() {
	console.log('Server started at port ' + port);
});
