class Organization < ApplicationRecord
  has_many :users
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def generate_invitation_code!
    self.invitation_code = SecureRandom.hex(8)
    self.invitation_code_created_at = Time.now
    save!
  end

  def invitation_code_expired?
    !invitation_code_created_at.present? || Time.now > invitation_code_created_at + ENV["EXPIRATION_TIME"].to_i.minutes
  end
end
