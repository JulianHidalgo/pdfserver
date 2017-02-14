'use strict';

const jsdom = require('jsdom');
const Canvas = require('canvas');

module.exports = function() {

	function renderChart(chartDefinition)
	{

		return new Promise((resolve, reject) => {

			jsdom.env({
				features: {
					QuerySelector: true
				},
				html: '<!doctype html><html><head></head><body><div id="canvas-holder"><canvas id="chart-area" width="' 
					  + chartDefinition.width 
					  + '" height="' 
					  + chartDefinition.height 
					  + '" /></div></body></html>',
				done: function (errors, window) {

					if (errors) {
						reject(errors);
					}

					global.window = window;

					let canvas = new Canvas (chartDefinition.width, chartDefinition.height)
		 			let ctx = canvas.getContext('2d');

					let Chart = require('chart.js');

					// Avoid the creation of an iframe for the chart
					// https://github.com/chartjs/Chart.js/issues/2210#issuecomment-223660423
					let origResizeListener = Chart.helpers.addResizeListener;
					Chart.helpers.addResizeListener = function(node, callback){
						if(Chart.defaults.global.responsive){
							origResizeListener(node, callback);
						}
					};
					Chart.defaults.global.responsive = false;

					ctx.canvas.style = {};
					ctx.canvas.style.display = 'block';
					window.myPie = new Chart(ctx, chartDefinition.data);

					let result = {
						name: chartDefinition.name,
						data: canvas.toDataURL()
					}
					
					resolve (result);
				}
			});

		});
		
	} 
	
	return {
        renderChart: renderChart
    };
}