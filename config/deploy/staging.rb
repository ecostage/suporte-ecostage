#Server configuration
server 'help-project.h1.tracersoft.com.br', user: 'ubuntu', roles: %w{web app db}
set :branch, 'staging'
#load servers from ansible/hosts
