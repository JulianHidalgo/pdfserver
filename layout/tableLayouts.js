'use strict';

module.exports =
{ 
    borderedTable: {
        hLineWidth: function(i, node) {
            return (i === 0 || i === node.table.body.length) ? 1 : 1;
        },
        vLineWidth: function(i, node) {
            return (i === 0 || i === node.table.widths.length) ? 1 : 1;
        },
        hLineColor: function(i, node) {
            return (i === 0 || i === node.table.body.length) ? 'black' : '#999';
        },
        vLineColor: function(i, node) {
            return (i === 0 || i === node.table.widths.length) ? 'black' : '#999';
        },
    },
    alternating: {
        fillColor: function(row, col, node) { return row > 0 && row % 2 ? 'yellow' : null; }
    },
    modern: {
        hLineWidth: function(i, node) {
                return (i === node.table.headerRows) ? 1 : (i === 0) ? 0 : 0.5;
        },
        vLineWidth: function(i, node) {
                return (i === 0 || i === node.table.widths.length) ? 0 : 0.5;
        },
        hLineColor: function(i, node) {
                return (i === 0 || i === node.table.headerRows || i === node.table.body.length) ? '#222' : '#999';
        },
        vLineColor: function(i, node) {
                return (i === 0 || i === node.table.widths.length) ? '#222' : '#999';
        },
    },
    modernHorizontal: {
        hLineWidth: function(i, node) {
                return (i === node.table.headerRows) ? 1 : (i === 0 || i === node.table.body.length) ? 0 : 0.5;
        },
        vLineWidth: function(i, node) {
                return 0;
        },
        hLineColor: function(i, node) {
                return (i == node.table.headerRows) ? '#222' : '#999';
        },
        vLineColor: function(i, node) {
                return (i === 0 || i === node.table.widths.length) ? '#222' : '#222';
        },
    },
    // Same as modernHorizontal, but with a line at the end
    modernHorizontalv2: {
        hLineWidth: function(i, node) {
                return (i === node.table.headerRows) ? 1 : (i < node.table.headerRows) ? 0 : 0.5;
        },
        vLineWidth: function(i, node) {
                return 0;
        },
        hLineColor: function(i, node) {
                return (i == node.table.headerRows) ? '#222' : '#999';
        },
        vLineColor: function(i, node) {
                return (i === 0 || i === node.table.widths.length) ? '#222' : '#222';
        },
    },
    signature: {
        defaultBorder: false,
        hLineWidth: function(i, node) {
            return 0.5;
        },
        vLineWidth: function(i, node) {
            return 0.5;
        },
        hLineColor: function(i, node) {
            return '#bbb';
        },
        vLineColor: function(i, node) {
            return '#bbb';
        },
    }
};