server "134.209.239.31", user: "deploy", roles: %w{app db web}, primary: true
set :rails_env, :production

set :ssh_options, {
 keys: %w(/Users/sad/.ssh/do_id_rsa),
 forward_agent: true,
 auth_methods: %w(publickey password),
 port: 2222
}
