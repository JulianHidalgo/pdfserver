'use strict';

const reportRenderer = require('./pdfRenderer')();

module.exports = function() {

    function renderPDF(request, reply) {
        // Extract the different section from the request payload
        let title = request.payload['title'];
        let templateName = request.payload['templateName'];
        let subTemplateNames = JSON.parse(request.payload['subTemplateNames']);
        let data = JSON.parse(request.payload['data']);        

        reportRenderer.renderPDF(title, templateName, subTemplateNames, data)
            .then(function(pdf) {
                // https://spin.atomicobject.com/2015/10/03/remote-pfs-node-js-express/
                // http://stackoverflow.com/questions/25901127/is-it-possible-to-manually-set-the-content-type-header-in-reply-file
                reply(pdf)
                    .header('Content-Type', "pdf")
                    .header("Content-Disposition", "attachment; filename=" + title)
            })
            
            .catch(function(err) {

                console.log(err);
                server.log(['error'], err);
                
            });
    };

    return {
        renderPDF,
        renderPDFv2
    };
}