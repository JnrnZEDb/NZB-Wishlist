define([
    "jquery",
    "underscore",
    "utils/Routes",
    "text!templates/wish_form.html"
], function($, _, Routes, wish_form){

    var my = function WishEditor(trigger_selector) {
        this.edit_selector   = trigger_selector;
        this.template        = _.template(wish_form);
        this.csrf_token      = $('meta[name=csrf-token]').attr('content');
        this.current_wish    = null;
        this.$modal          = null;
        this.categories      = null;
    };

    var proto = my.prototype;

    proto.bind = function() {
        var self = this;
        fetch_categories(self);

        $(document).on('click', this.edit_selector, function() {
            self.current_wish = get_wish($(this));
            self.show_modal(self.current_wish);
        });
    };

    proto.show_modal = function(wish) {
        var self = this;
        this.$modal = $(this.template(get_modal_data(wish, self)));

        this.$modal.on('click', '.btn-commit', function(e) {
            updated_wish = serialize_form(this);
            clear_errors(self);
            persist_wish(updated_wish, self);
        })
        .on('hide.bs.modal', function(){
            self.$modal.remove();
            self.$modal       = null;
            self.current_wish = null;
        })
        .modal('show');
    };

    var serialize_form = function(button) {
        var data = $(button).closest('.modal-content').find('form').serializeArray();
        var result = {};

        _.each(data, function(e){
            var values = _.values(e);
            result[values[0]] = values[1];
        });

        return result;
    };

    var persist_wish = function(wish, self) {
        var deferred = $.Deferred();
        deferred.done(handle_persist_response);

        if($.trim(wish.id) === '') {
            create_wish(wish, self, deferred);
        } else {
            update_wish(wish, self, deferred);
        }
    };

    var toggle_wish = function(wish, self) {

    };

    var handle_persist_response = function(resp, self) {
        if(resp.success) {
            var row = $('tr[data-wish-id=' + resp.wish.id + ']').get(0) || create_row(resp.wish);
            var attribs = {
                'data-wish-id':          resp.wish.id,
                'data-wish-name':        resp.wish.name,
                'data-wish-query':       resp.wish.query,
                'data-wish-category-id': resp.wish.category_id
            };

            $(row).attr(attribs)
                .find('td:nth-child(1)').html(set_wish_name(resp.wish, row)).end()
                .find('td:nth-child(2)').html('<kbd>' + resp.wish.query + '</kbd>').end()
                .find('td:nth-child(3)').text(resp.wish.category.canonical_name).end()
                .closest('table').removeClass('hide');
            self.$modal.modal('hide');
        } else {
            highlight_errors(resp.errors, self);
        }
    };

    var set_wish_name = function(wish, row) {
        var result_count = parseInt(row.children[3].innerText);
        if(result_count === 0 || isNaN(result_count)) {
            return wish.name;
        } else {
            var url = row.children[3].children[0].getAttribute('href');
            return $('<a />', { href: url, text: wish.name }).get(0).outerHTML;
        }
    };

    var highlight_errors = function(errors, self) {
        _.each(self.$modal.find('input,select'), function(input) {
            var field_errors = errors[input.getAttribute('name')];
            if(field_errors !== undefined){
                _.each(field_errors, function(e){
                    $(input).after($('<span />', { class: 'help-block', text: e }))
                        .closest('.form-group')
                        .addClass('has-error');
                });
            }
        });
    };

    var clear_errors = function(self) {
        self.$modal
            .find('span.help-block').remove().end()
            .find('.has-error').removeClass('has-error');
    };

    var create_row = function(wish) {
        return $('<tr />', {
            html: '<td /><td /><td /><td>0</td><td>N/A</td><td> \
                        <div class="btn-group"> \
                            <button class="btn btn-xs btn-default btn-wish-editor"> \
                                <i class="glyphicon glyphicon-pencil"></i> \
                            </button> \
                            <button class="btn btn-xs btn-default btn-wish-delete"> \
                                <i class="glyphicon glyphicon-remove"></i> \
                            </button> \
                        </div> \
                    </td>'
        }).appendTo('tbody').get(0);
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

    var fetch_categories = function(self) {
        $.get(Routes.categories_path()).done(function(resp) {
            self.categories = resp;
        });
    };

    var create_wish = function(wish, self, deferred) {
        $.post(Routes.wish_index_path(), { wish: wish, authenticity_token: self.csrf_token })
            .done(function(resp){
                deferred.resolve(resp, self)
            });
    };

    var update_wish = function(wish, self, deferred) {
        $.ajax({
            type: 'PATCH',
            data: { wish: wish, authenticity_token: self.csrf_token },
            url: Routes.wish_path({ id: wish.id })
        })
        .done(function(resp){
            deferred.resolve(resp, self);
        });
    }

    var get_modal_data = function(wish, self) {
        var new_wish = (wish === null || wish === undefined);
        var modal = {
            title:      new_wish ? "Create New Wish" : "Update Wish",
            btn_text:   new_wish ? "Create" : "Save",
            categories: self.categories
        };
        return {
            modal: modal,
            wish: wish || {}
        };
    };

    return my;
});