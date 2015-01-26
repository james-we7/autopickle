root_dir = File.dirname(__FILE__);

require 'optparse'

local_config = 'local-config.rb'
OptionParser.new do |opts|
  opts.on('-f [ARG]', '--config-file [ARG]', "The config file location (default: local-config.rb)") do |v|
    local_config = v
  end
end.parse!

require 'sinatra'
require File.join(root_dir, 'autopickle')
require File.join(root_dir, local_config)

set :bind, '0.0.0.0'

dic = GherkinDictionary.new(GHERKIN_ROOT_DIR)

get '/' do
  File.read(File.join(root_dir, 'public', 'index.html'))
end

get '/all', :provides => "text/plain" do
  dic.to_s
end

get '/autocomplete', :provides => :json do
  dic.find_terms(params[:query] || "").to_json
end

get '/assets/:file' do |file|
  send_file File.join(root_dir, 'public', file)
end
