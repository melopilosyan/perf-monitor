Rails.application.config.action_mailer.default_url_options = {
    host: ENV['APP_HOST']
}
Rails.application.config.action_mailer.default_options = {
    from: ENV['MAILER_DEFAULT_FROM']
}
