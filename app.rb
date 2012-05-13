require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'sequel'
require 'yaml'
require 'logger'

config = YAML.load_file('config.yml')
db = Sequel.sqlite(config['db_filepath'], :loggers => [Logger.new($stdout)])

require 'models/room.rb'
require 'models/message.rb'

set :haml, :format => :html5

get '/style.css' do
  scss :style
end

get '/' do
  @rooms = Room.dataset
  haml :index
end

get '/rooms/:id' do
  @room = Room[params[:id]]
  @messages = @room.messages_dataset.order_by(:stamp.desc).limit(50)
  haml :room
end
