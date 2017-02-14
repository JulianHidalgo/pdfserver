'use strict';

module.exports = [
    {
        method: 'GET',
        path: '/',
        handler: function (request, reply) {
            reply('PDF Server up and running.');
        }
    },
    {
        method: 'GET',
        path: '/test',
        handler: function (request, reply) {
            reply.file('./lib/test.html');
        }
    },
    {
        method: 'POST',
        path: '/build-report',
        handler: require('./handler')().renderPDF,
        config: {
            payload: {
                maxBytes: 52428800
            }
        }
    }
];