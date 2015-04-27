module ApplicationHelper

    def body_tag(&block)
        attribs = if has_javascript_controller?
            { data: { controller: params[:controller], action: params[:action] } }
        else
            {}
        end
        content_tag(:body, capture(&block), attribs)
    end

    def has_javascript_controller?
        js_path = Rails.root.join('app', 'assets', 'javascripts', 'controllers', "#{params[:controller]}.js")
        File.exists?(js_path)
    end

end
