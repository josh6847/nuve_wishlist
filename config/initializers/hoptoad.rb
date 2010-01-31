HoptoadNotifier.configure do |config|
  config.api_key = 'edc0e8b9d8ce92125339e1cb6c14afe5'
  config.ignore_user_agent << /ia_archiver/
  config.ignore_user_agent << /msnbot/
  config.ignore_user_agent << /Slurp/
  config.ignore_user_agent << /Googlebot/
  config.ignore_user_agent << /Exabot/
  config.ignore_user_agent << /Purebot/
end
