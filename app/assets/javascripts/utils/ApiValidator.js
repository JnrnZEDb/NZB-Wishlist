define([
    "jquery"
], function($) {
    var my = function() {
        this.csrf_token  = $('meta[name=csrf-token]').attr('content');
    };

    var proto = my.prototype;

    proto.bind = function() {
        var self = this;
        this.$key_input.on('blur', function(e) {
            validate_key(e, self);
        });
    };

    var validate_key = function(e, self) {
        var new_key      = self.$key_input.val();
        var new_url      = self.$url_input.val();
        var is_blank_key = $.trim(new_key) === '';

        self.$span.parent().toggleClass('has-error', is_blank_key);
        if((!is_blank_key && self.current_key !== new_key) || (self.current_url !== new_url)) {
            var deferred = $.Deferred();
            self.current_key = new_key;
            self.current_url = new_url;

            set_loading_state(self);
            request_validation(self, deferred);
            deferred.done(update_state);
        }
    };

    var set_loading_state = function(self) {
        self.$span.removeClass('label-success label-danger')
             .addClass('label-warning');
        self.$icon.removeClass('glyphicon-option-horizontal glyphicon-ok glyphicon-remove')
             .addClass('text-white glyphicon-refresh gly-spin');
    };

    var set_success_state = function(self) {
        self.$span.toggleClass('label-warning label-success');
        self.$icon.toggleClass('glyphicon-refresh glyphicon-ok gly-spin');
    };

    var set_failed_state = function(self) {
        self.$span.toggleClass('label-warning label-danger');
        self.$icon.toggleClass('glyphicon-refresh glyphicon-remove gly-spin');
    };

    var update_state = function(resp, self) {
        self.$submit.prop('disabled', !resp.success);
        var state_func = resp.success
            ? set_success_state
            : set_failed_state;
        state_func(self);
    };

    var request_validation = function(self, deferred) {
        $.post(self.submit_url, { url: self.current_url, key: self.current_key, authenticity_token: self.csrf_token })
            .done(function(resp) {
                deferred.resolve(resp, self);
            });
    };

    return my;
});