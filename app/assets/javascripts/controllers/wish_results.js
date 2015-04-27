define([
    "jquery",
    "utils/Routes"
], function($, Routes) {
    var class_toggles = 'gly-spin glyphicon-refresh glyphicon-cloud-upload';
    var my = {};

    my.init = function() { };

    my.index = function() {
        $('[data-toggle=tooltip]').tooltip();
        $(document).on('click', '.btn-download', download_nzb);
    };

    var download_nzb = function(e) {
        var elm        = e.currentTarget;
        var data       = get_result_data(elm);
        var url        = Routes.send_to_sabnzbd_wish_result_path(data);
        var csrf_token = $('meta[name=csrf-token]').attr('content');
        var deferred   = $.Deferred();

        deferred.done(function(resp) {
            handle_download_response(resp, elm);
        });

        $(elm).prop('disabled', true)
            .find('i')
            .toggleClass(class_toggles);

        $.post(url, { id: data.id, authenticity_token: csrf_token })
            .done(function(resp) {
                deferred.resolve(resp);
            });
    };

    var get_result_data = function(elm) {
        return {
            wish_id: elm.getAttribute('data-wish-id'),
            id:      elm.getAttribute('data-wish-result-id')
        };
    };

    var handle_download_response = function(resp, elm) {
        var new_btn_class = resp.success
            ? 'btn-success'
            : 'btn-danger';

        $(elm).prop('disabled', false)
            .removeClass('btn-default btn-success btn-danger')
            .addClass(new_btn_class)
            .find('i')
            .toggleClass(class_toggles);
    };

    return my;
});