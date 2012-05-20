class Message < Sequel::Model
  many_to_one :room

  db.create_table?(self.table_name) do
    primary_key :id
    Integer :room_id
    String :from
    String :body, :text => true
    Time :stamp
  end

  def self.store(room_id, from, body, stamp, delay)
    hash = {
      :room_id => room_id,
      :from => from,
      :body => body,
      :stamp => stamp,
    }
    return if delay && find(hash)
    create(hash)
  end
end
