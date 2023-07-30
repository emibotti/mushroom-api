class Mycelium < ApplicationRecord
  include MultiTenancyConcern

  belongs_to :strain_source, class_name: 'Mycelium', optional: true
  belongs_to :organization

  enum type: { Culture: 0, Spawn: 1, Bulk: 2, Fruit: 3 }
  enum substrate: { wood: 0, straw: 1, sawdust: 2, compost: 3 }
  enum container: { jar: 0, bag: 1, tray: 2 }

  validates :name, :type, :species, :inoculation_date, :generation, :prefix, presence: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :shelf_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :image_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
end
