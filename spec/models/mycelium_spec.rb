require 'rails_helper'

RSpec.describe Mycelium, type: :model do
  subject { build(:mycelium) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:species) }
  it { should validate_presence_of(:generation) }
  it { should validate_presence_of(:prefix) }

  it { should validate_numericality_of(:weight).is_greater_than_or_equal_to(0).allow_nil }
  it { should validate_numericality_of(:shelf_time).only_integer.is_greater_than_or_equal_to(0).allow_nil }

  # Associations
  it { should belong_to(:strain_source).class_name('Mycelium').optional }
  it { should belong_to(:organization) }
end
