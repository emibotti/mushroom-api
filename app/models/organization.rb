class Organization < ApplicationRecord
  has_many :users
  has_many :mycelia
  has_many :rooms
  has_many :events

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  cattr_accessor :current_id
  before_create :generate_invitation_code

  def to_json
    { organization: { code: get_invitation_code, id: id } }
  end

  def get_invitation_code
    return invitation_code unless invitation_code_expired?

    generate_invitation_code
    save!
    invitation_code
  end

  def generate_invitation_code
    self.invitation_code = SecureRandom.hex(8)
    self.invitation_code_created_at = Time.now
  end

  def invitation_code_expired?
    !invitation_code_created_at.present? || Time.now > invitation_code_created_at + ENV["EXPIRATION_TIME"].to_i.minutes
  end
end
