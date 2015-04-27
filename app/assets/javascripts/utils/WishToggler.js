define([
    "jquery",
    "underscore",
    "utils/Routes"
], function($, _, Routes){
    var my = function WishToggler(toggle_selector) {
        this.selector   = toggle_selector;
        this.csrf_token = $('meta[name=csrf-token]').attr('content');
    };

    var proto = my.prototype;

    proto.bind = function() {
        var self = this;
        $(document).on('click', this.selector, function(){
            var $this   = $(this);
            var id      = $this.closest('tr').get(0).getAttribute('data-wish-id');
            var state   = !$this.hasClass('btn-success');
            var payload = {
                wish: { id: id, fulfilled: state },
                authenticity_token: self.csrf_token
            };

            $this.toggleClass('btn-default btn-success');

            $.ajax({
                type: 'PATCH',
                url: Routes.wish_path({ id: id }),
                data: payload
            });
        });
    };

    return my;
});