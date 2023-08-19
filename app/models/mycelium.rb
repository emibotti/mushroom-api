class Mycelium < ApplicationRecord
  include MultiTenancyConcern

  belongs_to :strain_source, class_name: 'Mycelium', optional: true
  belongs_to :organization
  belongs_to :room, optional: true
  has_many :events

  enum species: %i[
    agaricus_bisporus
    pleurotus_ostreatus
    lentinula_edodes
    ganoderma_lucidum
    coprinus_comatus
    morchella_esculenta
    tricholoma_matsutake
    flammulina_velutipes
    hericium_erinaceus
    grifola_frondosa
    armillaria_mellea
    boletus_edulis
    cantharellus_cibarius
    tuber_melanosporum
    cordyceps
    trametes_versicolor
  ].index_with(&:to_s)

  enum substrate: %i[grain sawdust wood_chips straw compost gypsum coffee_grounds brown_rice_flour agar malt_extract agar_with_grain liquid_culture].index_with(&:to_s)
  enum container: %i[petri_dish test_tube mason_jar spawn_bag bulk_tray].index_with(&:to_s)

  validates :name, :type, :species, :inoculation_date, :generation, :prefix, :substrate, :container,  presence: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :shelf_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :image_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
end
