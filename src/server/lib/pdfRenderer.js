'use strict';

const path = require('path'),
      fs = require('fs');

// Change to the parent folder so the requires work
let currentPath = path.join(__dirname, '..');
process.chdir(currentPath);

const fonts        = require('../layout/fonts'),
      PdfPrinter   = require('pdfmake'),
      printer      = new PdfPrinter(fonts),
      MemoryStream = require('memorystream');

const Config = require('getconfig');

let _ = require('lodash');

const Mustache = require('mustache');

const styles       = require('../layout/styles');
const tableLayouts = require('../layout/tableLayouts');
const options      = { tableLayouts: tableLayouts };

const chartHandler = require('./chartHandler')();

module.exports = function() {

    let templates = {};
    function loadTemplates() {

        for (let templateDef of Config.templateDirectories) {
            let templatesPath = templateDef.directory;
            // If the directory is not an absolute path, we assume is relative to the parent 
            if (!path.isAbsolute(templateDef.directory)) {
                templatesPath = path.join(currentPath, templateDef.directory);
            }            
            let files = fs.readdirSync(templatesPath);
            files = _.filter(files, (file) => { return _.endsWith(file, '.template'); });
            for (let file of files) {
                let templateKey = templateDef.prefix + _.upperFirst(_.camelCase(file.replace('.template', '')));
                templates[templateKey] = fs.readFileSync( path.join(templatesPath, file), 'utf8');
            }
        }

    }

    function renderPDF(title, templateName, subTemplateNames, data) {

        return new Promise((resolve, reject) => {
            let chartsDefinition = data.chartsDefinition;

            // Render each chart (actually just getting a promise for each)
            let charTasks = [];
            if (chartsDefinition != null && chartsDefinition.length) {
                for (let i = 0; i < chartsDefinition.length; i++) {
                    charTasks.push(chartHandler.renderChart( chartsDefinition[i] ));
                }     
            }

            let template = templates[templateName];
            let partials = {};
            for (let subTemplateName of subTemplateNames) {
                partials[subTemplateName] = templates[subTemplateName];
            }
            //console.log(partials);
            
            let parsedTemplate = Mustache.render(template, data, partials);
            //console.log(parsedTemplate);
            let documentDefinition = JSON.parse(parsedTemplate);
            let footer = documentDefinition.footer;
            documentDefinition.footer = function(currentPage, pageCount) { 
                let newFooter = {};
                Object.assign(newFooter, footer);
                newFooter.text = newFooter.text + ' - Page ' + currentPage.toString() + ' of ' + pageCount;
                return newFooter; 
            };

            // Once all charts have been rendered
            Promise.all(charTasks)

                .then(function(chartImages) {

                    if (documentDefinition.images == null) {
                        documentDefinition.images = {};
                    }
                    // Add each chart to the images object (which is a plain object, not an array)
                    for (let chartImage of chartImages) {
                        documentDefinition.images[chartImage.name] = chartImage.data;
                    }

                    documentDefinition.styles = styles;
                    //console.dir(documentDefinition);
                    
                    let pdfDoc = printer.createPdfKitDocument(documentDefinition, options);
                    let memStream = new MemoryStream(null, {
                        readable : true
                    });

                    let stream = pdfDoc.pipe(memStream);

                    stream.on('finish', function() {
                        resolve(stream);    
                    });

                    pdfDoc.end();

                })
                
                .catch(function(err) {

                    console.log(err);
                    reject(err);
                    
                });
        });

    } 

    loadTemplates();

    return {
        renderPDF: renderPDF
    };
}