class Organization < ApplicationRecord
  has_many :users
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def generate_invitation_code!
    self.invitation_code = SecureRandom.hex(8)
    self.invitation_code_expires_at = Time.now + 2.minutes
    save!
  end

  def invitation_code_expired?
    invitation_code_expires_at.present? && invitation_code_expires_at < Time.now
  end
end
