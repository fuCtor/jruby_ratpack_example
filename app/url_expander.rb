module UrlExpander
  autoload :Server,           'url_expander/server'

  module Handler
    autoload :Status,         'url_expander/handler/status'
    autoload :Base,           'url_expander/handler/base'
    autoload :Expander,       'url_expander/handler/expander'
    autoload :Default,        'url_expander/handler/default'
  end
end
