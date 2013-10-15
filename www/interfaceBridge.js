
var cordova = require('cordova'),
    exec = require('cordova/exec');

var InterfaceBridge = function() {
    
}

InterfaceBridge.prototype.show = function (element, text, keepOpen, successCallback, failureCallback) {

    var options = {
    element: element,
    text: text,
    keepOpen: keepOpen
    };
        
    /*var success = function (msg) {
        //var event = JSON.parse(msg);
        successCallback(msg);
    };*/

    return exec(
            successCallback,
            failureCallback,
            'interfaceBridge',
            'Show',
            [options]);
};

InterfaceBridge.prototype.hide = function (element, successCallback, failureCallback) {
    
    var options = {
    element: element,
    };
    
    return exec(
            successCallback,
            failureCallback,
            'interfaceBridge',
            'Hide',
            [options]);
};

InterfaceBridge.prototype.disable = function (element, successCallback, failureCallback) {
    var options = {
    element: element,
    };
    
    return exec(
            successCallback,
            failureCallback,
            'interfaceBridge',
            'Disable',
            [options]);
};

var interfaceBridge = new InterfaceBridge();
module.exports = interfaceBridge;


