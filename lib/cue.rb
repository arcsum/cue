module Cue
  def self.items_for_store(store)
    items = store.keys.map { |k| store.read(k) }
    items.sort
  end
end
