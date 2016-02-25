if File.exists?('kuvakazim/Gemfile') then
  eval_gemfile('kuvakazim/Gemfile')
end

ruby '2.2.4'

source 'https://rubygems.org' do
  gem 'sinatra'
  gem 'puma'
  gem 'sinatra-jekyll', git: 'https://github.com/theyworkforyou/sinatra-jekyll', branch: 'master'
end
