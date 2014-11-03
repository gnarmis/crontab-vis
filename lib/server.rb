require 'sinatra'
require 'json'
require_relative 'crontab_vis'

set :public_folder, File.expand_path(File.join(File.dirname(__FILE__), '..', 'public'))

get '/data.json' do
  cv = CrontabVis.new
  cv.next_events('30 * * * *').to_json
end
