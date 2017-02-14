'use strict';

// Available properties: https://github.com/bpampuch/pdfmake/blob/master/src/styleContextStack.js#L85
module.exports = {
    header: {
        fontSize: 20,
        bold: true,
        margin: [0, 10, 0, 10],
        alignment: 'center'
    },
    subheader: {
        fontSize: 16,
        bold: true,
        margin: [0, 20, 0, 15],
        alignment: 'left'
    },
    tableHeader: {
        bold: true,
        color: 'black',
        margin: [4, 4, 4, 3],
        fillColor: '#eee',
    },
    tableHeaderCentered: {
        bold: true,
        color: 'black',
        margin: [0, 4, 0, 3],
        alignment: 'center',
        fillColor: '#eee',
    },
    tableHeaderRight: {
        bold: true,
        color: 'black',
        margin: [0, 4, 0, 3],
        alignment: 'right',
        fillColor: '#eee',
    },
    tableHeader1: {
        bold: true,
        color: 'black',
        margin: [4, 4, 4, 0],
        fillColor: '#eee',
    },
    tableHeader1Centered: {
        bold: true,
        color: 'black',
        margin: [0, 4, 0, 0],
        alignment: 'center',
        fillColor: '#eee',
    },
    tableHeader2: {
        bold: true,
        color: 'black',
        margin: [4, 0, 4, 3],
        fillColor: '#eee',
    },
    tableHeader2Centered: {
        bold: true,
        color: 'black',
        margin: [0, 0, 0, 3],
        alignment: 'center',
        fillColor: '#eee',
    },
    tableCell: {
        margin: [4, 2, 0, 2]
    },
    tableCellCentered: {
        margin: [0, 2, 0, 2],
        alignment: 'center'
    },
    tableCellRight: {
        margin: [0, 2, 0, 2],
        alignment: 'right'
    },
    remark: {
        bold: 'true',
        margin: [0, 10, 0, 10],
        alignment: 'center'
    },
    centered: {
        alignment: 'center'
    },
    rightAligned: {
        alignment: 'right'
    },
    small: {
        fontSize: 8
    }

};