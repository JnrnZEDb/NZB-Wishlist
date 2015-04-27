define([
    "jquery",
    "underscore",
    "utils/Routes",
    "text!templates/wish_delete.html"
], function($, _, Routes, wish_delete){

    var my = function WishDeleter(trigger_selector) {
        this.selector     = trigger_selector;
        this.template     = _.template(wish_delete);
        this.csrf_token   = $('meta[name=csrf-token]').attr('content');
        this.$modal       = null;
    };

    var proto = my.prototype;

    proto.bind = function() {
        var self = this;
        $(document).on('click', this.selector, function(){
            wish = get_wish($(this))
            self.show_modal(wish);
        });
    };

    proto.show_modal = function(wish) {
        var self = this;
        this.$modal = $(this.template(wish));

        this.$modal.on('click', '.btn-commit', function(e){
            var deferred = $.Deferred();
            deferred.done(remove_row);
            delete_wish(wish, self, deferred);
        }).on('hide.bs.modal', function(){
            self.$modal.remove();
            self.$modal = null;
        }).modal('show');
    };

    var remove_row = function(resp, self) {
        if(resp.success) {
            $('tr[data-wish-id=' + resp.wish.id + ']').remove();
        }
        self.$modal.modal('hide');
    };

    var get_wish = function($btn) {
        var row = $btn.closest('tr')[0];
        var new_wish = (row === undefined);

        return {
            id:          new_wish ? null : row.getAttribute('data-wish-id'),
            name:        new_wish ? null : row.getAttribute('data-wish-name'),
            query:       new_wish ? null : row.getAttribute('data-wish-query'),
            category_id: new_wish ? null : row.getAttribute('data-wish-category-id')
        };
    };

    var delete_wish = function(wish, self, deferred) {
        $.ajax({
            type: 'DELETE',
            data: { wish: wish, authenticity_token: self.csrf_token },
            url: Routes.wish_path({ id: wish.id })
        }).done(function(resp) {
            deferred.resolve(resp, self);
        });
    };

    return my;
});