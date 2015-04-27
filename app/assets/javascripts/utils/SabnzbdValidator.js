define([
    "jquery",
    "utils/Routes",
    "utils/ApiValidator"
], function($, Routes, ApiValidator) {
    var my = function(url_input_selector, key_input_selector, save_btn_selector) {
        this.$key_input  = $(key_input_selector);
        this.$url_input  = $(url_input_selector);
        this.$submit     = $(save_btn_selector);
        this.$span       = this.$key_input.next();
        this.$icon       = this.$span.children(':first');
        this.current_key = this.$key_input.val();
        this.current_url = this.$url_input.val();
        this.submit_url  = Routes.validate_sabnzbd_key_settings_path();
    };

    my.prototype = new ApiValidator;

    return my;
});