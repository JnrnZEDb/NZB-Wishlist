class QueueController < ApplicationController
    include QueueHelper
    before_filter :set_client

    def index
        begin
            raw_queue = @client.queue
            @queue    = format_queue(raw_queue)

            respond_to do |format|
                format.html
                format.json do
                    raw_queue["categories"] = @queue.categories
                    render json: raw_queue
                end
            end
        rescue
            render 'sabnzbd_error'
        end
    end

    def action
        result = case requested_action
        when *queue_actions
            @client.send(requested_action)
        when *item_actions
            @client.send(requested_action, nzo_id)
        when 'change_category'
            @client.change_category(nzo_id, new_category)
        else
            { :status => false }
        end
        render json: result
    end

    private

    def set_client
        @client = SabnzbdClient.new(current_settings.sabnzbd_url, current_settings.sabnzbd_apikey)
    end

    def format_queue(raw_queue)
        OpenStruct.new(raw_queue).tap do |queue|
            queue.slots       = queue.slots.map { |s| OpenStruct.new(s) }
            queue.categories  = queue.categories.map &method(:format_category)
        end
    end

    def queue_actions
        ['pause_queue', 'resume_queue']
    end

    def item_actions
        ['pause_item', 'resume_item', 'delete_item']
    end

    def requested_action
        params[:request][:action]
    end

    def nzo_id
        params[:request][:nzo_id]
    end

    def new_category
        case cat = params[:request][:category].downcase
        when 'default'
            '*'
        else
            cat
        end
    end
end
