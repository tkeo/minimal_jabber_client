class Room < Sequel::Model
  one_to_many :messages

  db.create_table?(self.table_name) do
    primary_key :id
    String :name
    String :domain
  end

  def join(client, resource)
    muc = Jabber::MUC::MUCClient.new(client)
    room_jid = Jabber::JID.new(name, domain, resource)
    muc.add_message_callback do |m|
      jid = Jabber::JID.new(m.from)
      delay = m.first_element("delay") || m.x("jabber:x:delay")
      if delay
        stamp = delay.attributes["stamp"]
        stamp << "Z" unless stamp.end_with?("Z")
        t = Time.parse(stamp).getlocal
      else
        t = Time.now
      end
      puts "[#{t.strftime('%Y/%m/%d %T')}] <#{jid.resource}> #{m.body}"
      Message.store(self.id, jid.resource, m.body, t, !!delay)
    end
    muc.join(room_jid)
  end
end
