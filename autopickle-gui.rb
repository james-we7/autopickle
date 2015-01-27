root_dir = File.dirname(__FILE__);

require 'optparse'

options = { :local_config => 'local-config.rb' }
OptionParser.new do |opts|
  opts.on('-c [ARG]', '--config-file [ARG]', "The config file location (default: local-config.rb)") do |v|
    options[:local_config] = v
  end
  opts.on('-f [ARG]', '--features-dir [ARG]', "The location of the directory containing the feature files") do |v|
    options[:features_dir] = v
  end
end.parse!

require 'sinatra'
require File.join(root_dir, 'autopickle')
begin
  require File.join(root_dir, options[:local_config])
rescue LoadError
  require File.join(root_dir, 'local-config.rb.example')
end

if options[:features_dir] !=  nil
  GHERKIN_ROOT_DIR = options[:features_dir]
end

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
