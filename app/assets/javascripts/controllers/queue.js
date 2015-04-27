define([
    "jquery",
    "utils/QueueHandler",
    "utils/QueueUpdater"
], function($, QueueHandler, QueueUpdater) {
    var my = {};

    my.init = function() {
        this.handler = new QueueHandler();
        this.updater = new QueueUpdater();
    };

    my.index = function() {
        $('[data-toggle=tooltip]').tooltip();
        this.handler.bind();
        this.updater.bind();
    };

    return my;
});