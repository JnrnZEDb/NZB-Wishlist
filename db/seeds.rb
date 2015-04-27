# Seed Settings Record

unless Setting.any?
    setting = Setting.new(
        result_limit:        20,
        search_interval:     1,
        auto_download:       true,
        fulfill_on_download: true
    )
    setting.save(validate: false)
    setting.update_column(:setup_complete, false)
end