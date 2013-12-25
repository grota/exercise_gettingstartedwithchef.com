# See http://docs.opscode.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
cookbook_path            ["#{current_dir}/../cookbooks"]
#log_level                :info
#log_location             STDOUT
#node_name                "grota"
#client_key               "#{current_dir}/grota.pem"
#validation_client_name   "grota-na-validator"
#validation_key           "#{current_dir}/grota-na-validator.pem"
#chef_server_url          "https://api.opscode.com/organizations/grota-na"
#cache_type               'BasicFile'
#cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
