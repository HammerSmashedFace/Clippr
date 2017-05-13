'use strict';

var app = require('express')();
var bodyParser = require('body-parser');

var server = require('./app/socket')(app);

var port = process.env.PORT || 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', function(request, responce) {
	responce.send("Hello world");
});

server.listen(port);
