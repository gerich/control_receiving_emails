resources :issues_import_emails, :issues_import_servers

get 'admin/issues_import/show_settings', to: 'import#show', as: 'show_settings'
