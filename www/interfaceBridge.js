
var InterfaceBridge = function() {
    
}

InterfaceBridge.prototype.show = function (element, text, keepOpen, successCallback, failureCallback) {

    var options = {
    element: element,
    text: text,
    keepOpen: keepOpen
    };
        
    var success = function (msg) {
        //var event = JSON.parse(msg);
        successCallback(msg);
    };

    return cordova.exec(
            success,
            failureCallback,
            'interfaceBridge',
            'Show',
            [options]);
};

InterfaceBridge.prototype.hide = function (element, successCallback, failureCallback) {
    
    var options = {
    element: element,
    };
    
    return cordova.exec(
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
    
    return cordova.exec(
            successCallback,
            failureCallback,
            'interfaceBridge',
            'Disable',
            [options]);
};


module.exports = new InterfaceBridge();


