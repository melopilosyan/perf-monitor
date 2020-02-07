Rails.application.config.action_mailer.default_url_options = {
    host: ENV['APP_HOST']
}
Rails.application.config.action_mailer.default_options = {
    from: ENV['MAILER_DEFAULT_FROM']
}

Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    user_name: ENV['GMAIL_USER_NAME'],
    password: ENV['GMAIL_APP_PASSWORD'],
    authentication: 'plain',
    enable_starttls_auto: true
}
