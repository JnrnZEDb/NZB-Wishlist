define([
    "jquery",
    "utils/NewsnabValidator",
    "utils/SabnzbdValidator"
], function($, NewsnabValidator, SabnzbdValidator) {
    var my = {};

    my.init = function() {
        this.nn_validator = new NewsnabValidator('.nn-url', '.nn-apikey input', '.btn-save');
        this.sb_validator = new SabnzbdValidator('.sb-url', '.sb-apikey input', '.btn-save');
    };

    my.edit = function() {
        this.nn_validator.bind();
        this.sb_validator.bind();
    };

    my.update = function() {
        my.edit();
    };

    return my;
});