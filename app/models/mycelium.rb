class Mycelium < ApplicationRecord
  enum type: { culture: 0, spawn: 1, bulk: 2, fruit: 3 }
  enum substrate: { wood: 0, straw: 1, sawdust: 2, compost: 3 }
  enum container: { jar: 0, bag: 1, tray: 2 }

  validates :name, :type, :species, :inoculation_date, :generation, :prefix, presence: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :shelf_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :image_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true

  belongs_to :strain_source, class_name: 'Mycelium', optional: true
end
