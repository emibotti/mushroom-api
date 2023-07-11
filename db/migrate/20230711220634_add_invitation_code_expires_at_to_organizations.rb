class AddInvitationCodeExpiresAtToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :invitation_code_expires_at, :datetime
  end
end
