define([
    "jquery",
    "utils/WishEditor",
    "utils/WishDeleter",
    "utils/WishToggler",
], function($, WishEditor, WishDeleter, WishToggler){
    var my = {};

    my.init = function() {
        init_shared_services();
    };

    my.index = function() {
        new WishEditor('.btn-wish-editor').bind();
    };

    var init_shared_services = function() {
        $('[data-toggle=tooltip]').tooltip();
        new WishDeleter('.btn-wish-delete').bind();
        new WishToggler('.btn-wish-toggle').bind();
    };

    return my;
});