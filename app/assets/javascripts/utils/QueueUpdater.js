define([
    "jquery",
    "underscore",
    "utils/Routes"
], function($, _, Routes) {

    var my = function QueueUpdater() {
        this.update_interval = 1000;
        this.endpoint        = Routes.queue_index_path({ format: 'json' });
        this.$queue_info     = $('.queue-info');
        this.$slots          = $('tr[data-nzo-id]');

        this.queue_info_tmpl = _.template('<%= status %> | ETA <%= timeleft %> | <%= speed %>/sec');
        this.item_info_tmpl  = _.template('<%= size %> total | <%= sizeleft %> remaining | ETA <%= timeleft %>');
        this.percent_tmpl    = _.template('<%= p %>%');
    };

    var proto = my.prototype;

    proto.bind = function() {
        var self = this;
        setInterval(function() {
            retrieve_queue(self);
        }, this.update_interval);
    };

    var retrieve_queue = function(self) {
        $.get(self.endpoint).done(function(resp) { update_view(resp, self); });
    };

    var update_view = function(queue, self) {
        self.$queue_info.text(self.queue_info_tmpl(
            { status: queue.status, timeleft: queue.timeleft, speed: queue.speed }
        ));

        _.each(queue.slots, function(slot){
            var $row    = self.$slots.filter('tr[data-nzo-id=' + slot.nzo_id + ']');
            var percent = self.percent_tmpl({ p: slot.percentage });
            var info    = self.item_info_tmpl({ size: slot.size, sizeleft: slot.sizeleft, timeleft: slot.timeleft });

            $row.find('.item-info').text(info).end()
                .find('.progress-bar').css({ width: percent}).end()
                .find('.progress-value').text(percent);
        });
    };

    return my;
});