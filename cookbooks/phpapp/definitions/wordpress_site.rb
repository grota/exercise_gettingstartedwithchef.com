define :wordpress_site, :path => "/var/www/phpapp", :database => "phpapp", :db_username => "phpapp", :db_password => "phpapp", :template => "site.conf.erb" do

  # download and extract wordpress
  wordpress_latest = Chef::Config[:file_cache_path] + "/wordpress-latest.tar.gz"

  remote_file wordpress_latest do
    source "http://wordpress.org/latest.tar.gz"
    mode "0644"
    checksum 'c419de49816b6483ab387567222898c02e8acd6ce64d6466a38f2fc05ebefb85'
  end

  directory params[:path] do
    owner "root"
    group "root"
    mode "0755"
    action :create
    recursive true
  end

  execute "untar-wordpress" do
    cwd params[:path]
    command "tar --strip-components 1 -xzf " + wordpress_latest
    creates params[:path] + "/wp-settings.php"
  end

  #install wp
  wp_secrets = Chef::Config[:file_cache_path] + '/wp-secrets.php'

  remote_file wp_secrets do
    source 'https://api.wordpress.org/secret-key/1.1/salt/'
    action :create_if_missing
    mode 0644
  end

  ruby_block 'fetch-salt-data' do
    block do
      salt_data = File.read(wp_secrets)
    end
    action :create
  end
  salt_data = File.read(wp_secrets)

  template params[:path] + '/wp-config.php' do
    source 'wp-config.php.erb'
    mode 0755
    owner 'root'
    group 'root'
    variables(
      :database        => params[:database],
      :user            => params[:db_username],
      :password        => params[:db_password],
      :wp_secrets      => salt_data)
  end

  docroot = params[:path]
  # params[:name] esiste ed e' il nome prima del blocco
  server_name = params[:name]
  # Due to a Chef quirk we can't pass our params to another definition
  web_app server_name do
    template 'site.conf.erb'
    docroot docroot
    server_name server_name
  end
end
