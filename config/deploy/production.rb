role :app, %w{ubuntu@project-help.tracersoft.com.br}
role :web, %w{ubuntu@project-help.tracersoft.com.br}
role :db,  %w{ubuntu@project-help.tracersoft.com.br}

set :nginx_domains, "suporte.tracersoft.com.br project-help.tracersoft.com.br"
set :app_server_socket, "/tmp/project-help.sock"
