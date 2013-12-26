current_dir = File.expand_path(File.dirname(__FILE__))
file_cache_path current_dir
cookbook_path "#{current_dir}/cookbooks/"
data_bag_path "#{current_dir}/data_bags"
#node_name 'grota'
#verbose_logging true
