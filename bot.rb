#!/usr/bin/env ruby
require 'xmpp4r'
require 'xmpp4r/client'
require 'xmpp4r/muc'
require 'sequel'
require 'pry'
require 'yaml'

config = YAML.load_file('config.yml')
db = Sequel.sqlite(config['db_filepath'])

require 'models/room'
require 'models/message'

def login(config)
  jid = Jabber::JID.new(config['uid'], config['server'], config['resource'])
  client = Jabber::Client.new(jid)
  client.connect
  client.auth(config['password'])
  client.send(Jabber::Presence.new(nil, config['resource'], -1))
  client
end

client = login(config)

rooms = Room.dataset.all
rooms.each do |room|
  room.join(client, config['nickname'])
end

loop do
  sleep 0.1
end
