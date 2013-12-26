# this stuff does not work, not sure if this is because a change in the scope of vars in blocks in ruby post 1.8.7

#local_var = ''
ruby_block 'testing' do
  block do
    local_var = 'ciao'
    puts local_var
  end
  action :create
end
#puts 'dopo' + local_var

template '/tmp/sitcazzi' do
  source 'sticazzi.erb'
  variables(:primavar => local_var)
end
