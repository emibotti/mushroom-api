class PrefixCount < ApplicationRecord
  includes MultiTenancyConcern

  validates :prefix, presence: true
  validates :count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :prefix, uniqueness: { scope: :organization_id }
end
