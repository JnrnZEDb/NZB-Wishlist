class WishResultsController < ApplicationController
    before_filter :get_nzb, only: [:download, :send_to_sabnzbd]

    def index
        @wish = Wish.eager_load(:results).where(id: params[:wish_id]).first
        redirect_to root_path if @wish.nil?
    end

    def download
        send_data @nzb.blob, filename: @nzb.filename, type: 'application/x-nzb'
    end

    def send_to_sabnzbd
        begin
            sabnzbd = SabnzbdClient.new(current_settings.sabnzbd_url, current_settings.sabnzbd_apikey)
            result  = sabnzbd.upload_nzb(@nzb)

            if result.nil? || !result["status"]
                failure message: 'Failed to send to SABnzbd.'
            else
                success message: 'Download successful.'
            end
        rescue => e
            failure message: "Couldn't connect to SABnzbd", exception: e.message
        end
    end

    private

    def get_nzb
        wish_result = WishResult.where(id: params[:id]).first
        return redirect_to root_path if wish_result.nil?

        client  = NewsnabClient.new(current_settings.newsnab_url, current_settings.newsnab_apikey)
        @nzb    = client.get_nzb(wish_result)

        redirect_to wish_result_path(wish_result.wish) if @nzb.nil?
    end
end
