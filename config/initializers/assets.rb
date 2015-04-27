# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

if Rails.env.development?
    # Add javascript relative paths as requirejs modules
    # only for development, because... well I don't know.
    js_path = Rails.root.join('app', 'assets', 'javascripts')
    Rails.application.config.assets.precompile += Dir[Rails.root.join(js_path, '**/*/*.js')].map do |path|
        path.sub("#{js_path}/", '')
    end
end
