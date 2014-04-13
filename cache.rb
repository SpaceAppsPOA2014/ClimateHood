class Cache
  @@data = []

  def self.is_loaded()
    @@data != []
  end

  def self.add(item)
    @@data << item
  end

  def self.data()
    return @@data
  end
end
