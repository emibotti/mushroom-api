class AddInvitationCodeToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :invitation_code, :string
  end
end
