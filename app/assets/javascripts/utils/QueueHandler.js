define([
    "jquery",
    "underscore",
    "utils/Routes"
], function($, _, Routes) {

    var my = function QueueHandler() {
        this.csrf_token = { authenticity_token: $('meta[name=csrf-token]').attr('content') };
    };

    var proto = my.prototype;

    proto.bind = function() {
        var self = this;
                    // queue actions
        $(document).on('click', '[data-queue-action=resume_queue]', function(e) { self.toggle_queue(true);  })
                   .on('click', '[data-queue-action=pause_queue]',  function(e) { self.toggle_queue(false); })
                    // item actions
                   .on('click', '[data-queue-action=resume_item]', function(e) {
                        self.toggle_item(get_nzo_id(e.currentTarget), true);
                    })
                    .on('click', '[data-queue-action=pause_item]',  function(e) {
                        self.toggle_item(get_nzo_id(e.currentTarget), false);
                    })
                    .on('click', '[data-queue-action=delete_item]', function(e) {
                        self.delete_item(get_nzo_id(e.currentTarget));
                    })
                    .on('click', '[data-queue-action=change_category] a', function(e) {
                        e.preventDefault();
                        self.change_category(get_nzo_id(e.currentTarget), e.currentTarget.text);
                    });
    };

    proto.toggle_queue = function(state) {
        var action   = state ? 'resume_queue' : 'pause_queue';
        var $button  = $('[data-queue-action=' + action + ']');
        var params   = { request: { action:  action } };
        var payload  = $.extend({}, this.csrf_token, params);

        submit_request($button, toggle_queue_buttons, payload);
    };

    proto.toggle_item = function(nzo_id, state) {
        var action  = state ? 'resume_item' : 'pause_item';
        var $button = $('tr[data-nzo-id=' + nzo_id + '] [data-queue-action=' + action + ']');
        var params  = { request: { action: action, nzo_id: nzo_id } };
        var payload = $.extend({}, this.csrf_token, params);

        submit_request($button, function() { toggle_item_buttons(nzo_id); }, payload);
    };

    proto.delete_item = function(nzo_id) {
        var $button = $('tr[data-nzo-id=' + nzo_id + '] [data-queue-action=delete_item]');
        var payload = $.extend({}, this.csrf_token, { request: { action: 'delete_item', nzo_id: nzo_id } });

        submit_request($button, function(){
            $button.closest('tr')
                .find('button')
                .prop('disabled', true).end()
                .hide('slow', function() { $(this).remove(); });
        }, payload);
    };

    proto.change_category = function(nzo_id, new_category) {
        var payload = $.extend({}, this.csrf_token, { request: {
            action: 'change_category',
            nzo_id: nzo_id,
            category: new_category
        }});

        $('[data-nzo-id=' + nzo_id + '] .caption').text(new_category);
        perform(payload);
    };

    var get_nzo_id = function(elm) {
        return $(elm).closest('tr').data('nzo-id');
    };

    var toggle_queue_buttons = function(btn) {
        $('.wishlist-actions').find('button').toggleClass('hide');
    };

    var toggle_item_buttons = function(nzo_id) {
        $('tr[data-nzo-id=' + nzo_id + '] .btn-item').toggleClass('hide');
    };

    var submit_request = function($button, success_callback, payload) {
        var deferred = $.Deferred();

        set_working($button, true);
        deferred.done(function(resp) {
            if(resp.status === true) {
                success_callback();
            }
            set_working($button, false);
        });

        perform(payload, deferred);
    };

    var set_working = function($button, state) {
        var $i    = $button.find('i');
        var glyph = state ? $i.attr('class').split(' ')[1] : $button.data('icon');

        if(state) {
            $button.data('icon', glyph);
        }

        $button.prop('disabled', state);
        $i.toggleClass('glyphicon-refresh gly-spin', state)
            .toggleClass(glyph, !state);
    };

    var perform = function(payload, deferred) {
        $.post(Routes.action_queue_index_path(), payload)
            .done(function(resp) {
                if(deferred != null && deferred !== undefined) {
                    deferred.resolve(resp);
                }
            });
    };

    return my;
});