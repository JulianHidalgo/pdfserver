'use strict';

const Config = require('getconfig');
const Hapi = require('hapi');
const winston = require('winston'),
      logger = new (winston.Logger)({
            transports: [
                new (winston.transports.Console)(),
                new (winston.transports.File)({ filename: './pdfserver.log' })
            ]});
const server = new Hapi.Server();
server.connection({
    host: Config.host,
    port: Config.port,
});

const pdfHandler = require('./lib/handler')();

function log(event, tags) {
    
    if (tags.info) {
       logger.info(event.data);
    }
    else if (tags.error) {
       logger.error(event.data);            
    }
    else {
        logger.debug(event);
    }

}

server.register(require('inert'), (err) => {

    if (err) {
        throw err;
    }

    server.route(require('./lib/routes'));

	server.on('log', (event, tags) => { log (event, tags); });
    server.on('request', (request, event, tags) => { log (event, tags); });

	server.start((err) => {

	    if (err) {
	        throw err;
	    }
	    console.log('Server running at:', server.info.uri);
        console.log(__dirname);
	});

});

