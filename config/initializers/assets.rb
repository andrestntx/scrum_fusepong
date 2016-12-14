# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.

Rails.application.config.assets.precompile += %w( metisMenu/metisMenu.min.css )
Rails.application.config.assets.precompile += %w( datepicker/bootstrap-datepicker.min.css )
Rails.application.config.assets.precompile += %w( projects.css )
Rails.application.config.assets.precompile += %w( sb-admin-2.css )
Rails.application.config.assets.precompile += %w( login.scss )
Rails.application.config.assets.precompile += %w( fullcalendar/fullcalendar.css )
Rails.application.config.assets.precompile += %w( fullcalendar/fullcalendar.print.css )

Rails.application.config.assets.precompile += %w( bootstrap/bootstrap.min.js )
Rails.application.config.assets.precompile += %w( moment/moment.min.js )
Rails.application.config.assets.precompile += %w( fullcalendar/fullcalendar.js )
Rails.application.config.assets.precompile += %w( datepicker/bootstrap-datepicker.min.js )
Rails.application.config.assets.precompile += %w( metisMenu/metisMenu.min.js )
Rails.application.config.assets.precompile += %w( sb-admin-2.js )
