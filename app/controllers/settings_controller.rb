class SettingsController < ApplicationController
    def edit; end

    def update
        if @settings.update_attributes(params[:setting].permit!)
            set_schedule if @settings.update_schedule?
            flash.now[:success] = "Settings updated!"
        else
            flash.now[:error] = "Please correct the errors below."
        end
        render :edit
    end

    def validate_newsnab_key
        client = NewsnabClient.new(params[:url], params[:key])

        begin
            if client.valid_apikey?
                service = CategoryService.new(client)
                render json: service.populate_from_newsnab
            else
                failure error: client.error["description"]
            end
        rescue => e
            failure error: 'Invalid Newsnab indexer.', exception: e.message
        end
    end

    def validate_sabnzbd_key
        client = SabnzbdClient.new(params[:url], params[:key])

        begin
            if client.valid_apikey?
                success message: nil
            else
                failure error: client.error["error"]
            end
        rescue => e
            failure error: 'Invalid SABnzbd instance.', exception: e.message
        end
    end

    private

    def set_schedule
        job = UpdateSearchScheduleJob.new
        job.delay.perform
    end
end
