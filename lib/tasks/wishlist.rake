namespace :wishlist do

    namespace :tasks do

        desc "Searches Newsnab for all unfulfilled items in the wishlist."
        task search: :environment do
            setting = Setting.first

            unless setting.setup_complete?
                puts "\e[034m*\e[0m Setup not complete, nothing to do."
                next
            end

            service = WishService.new(NewsnabClient.new(setting.newsnab_url, setting.newsnab_apikey))
            new_results = []

            Wish.unfulfilled.each do |wish|
                print "\e[034m*\e[0m Searching for \e[035m#{wish.name}\e[0m... "
                result = service.search_newsnab(wish, setting.result_limit)
                new_results.push(wish.name) if (result.data[:added] || 0) > 0
                color = result.success ? 32 : 31
                puts "\e[0#{color}m#{result.message}\e[0m"
            end

            if setting.notify? && new_results.any?
                msg_service = NotificationService.new(setting.pushover_apikey)
                message = "Found new results for #{new_results.to_sentence}!"
                if message.length > NotificationService::MAX_MESSAGE_LENGTH
                    message = "Found new results for #{new_results.length} wishes!"
                end
                msg_service.notify(message)
            end
        end

    end

    namespace :js do

        desc "Generates a requirejs module for generating routes in javascript based on the application routing."
        task routes: :environment do
            methods          = %w( GET PUT POST PATCH DELETE )
            routing_template = Rails.root.join('app', 'views', 'shared', '_routes.js.erb')
            generated_file   = Rails.root.join('app', 'assets', 'javascripts', 'utils', 'Routes.js')

            data = %x( cd "#{Rails.root}" && bundle exec rake routes ).strip.split("\n").inject({}) do |routes, row|
                r = row.split(/\s+/).reject(&:blank?)

                if methods.include?(r[1])
                    name = "#{r[0]}_path".to_sym
                    routes[name] = r[2].remove(/\(\.:format\)/).gsub(/:(\w+)/, '<%= \1 %>')
                end

                routes
            end

            File.open(generated_file, "w") do |f|
                template_contents = File.read(routing_template)
                f << ERB.new(template_contents).result(binding)
            end

            dname = generated_file.relative_path_from(Rails.root).to_s
            puts "\e[034m*\e[0m Routing javascript module has been generated at \e[032m#{dname}\e[0m (#{data.length} total routes)."
        end

    end

end