class Message < Sequel::Model
  many_to_one :room

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
