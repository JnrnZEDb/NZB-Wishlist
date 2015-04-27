require 'open3'

class SabnzbdClient
    include HTTParty
    default_params output: 'json'
    default_options.update verify: false

    attr_reader :error

    def initialize(url, apikey)
        self.class.base_uri File.join(url, '/api')
        self.class.default_params.merge!(apikey: apikey)
    end

    def valid_apikey?
        categories.present?
    end

    # general information (version, queue, warnings)
    [:version, :queue, :warnings].each do |action|
        define_method(action) do
            resp = perform_request mode: action.to_s
            return resp[action.to_s] unless resp.nil?
        end
    end

    def categories
        resp = perform_request mode: 'get_cats'
        return resp['categories'] unless resp.nil?
    end

    # queue actions (pause_queue, resume_queue)
    [:pause, :resume].each do |action|
        define_method("#{action}_queue") do
            resp = perform_request mode: action.to_s
            return resp.parsed_response unless resp.nil?
        end
    end

    # item actions (pause_item, resume_item, delete_item)
    [:pause, :resume, :delete].each do |action|
        define_method("#{action}_item") do |nzo_id|
            resp = perform_request mode: 'queue', name: action.to_s, value: nzo_id
            return resp.parsed_response unless resp.nil?
        end
    end

    def change_category(nzo_id, category)
        resp = perform_request mode: 'change_cat', value: nzo_id, value2: category
        return resp.parsed_response unless resp.nil?
    end

    # why oh why can I not do a fucking multiform post
    def upload_nzb(nzb)
        cmd = formatted_curl_command(nzb.wish_result.title)
        result = {}

        io = StringIO.new(nzb.blob)
        Open3.popen3(cmd) do |i,o,e,t|
            while !io.eof? do
                i.write(io.readline)
            end
            i.close
            result = JSON.parse(o.read)
        end

        result
    end

    private

    def perform_request(opts = {})
        resp = self.class.get('', query: opts)
        unless (@error = resp["error"])
            return resp
        end
    end

    def formatted_curl_command(nzb_name)
        "curl #{sabnzbd_url} -F apikey=#{sabnzbd_apikey} -F mode=addfile -F output=json -F \"nzbname=#{nzb_name}\" -F \"name=@-\" -k"
    end

    def sabnzbd_url
        SabnzbdClient.base_uri
    end

    def sabnzbd_apikey
        SabnzbdClient.default_params[:apikey]
    end
end