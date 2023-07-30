module MultiTenancyConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :organization

    before_create :set_organization_id
    default_scope { where(organization_id: Organization.current_id) }
  end

  private

  def set_organization_id
    self.organization_id ||= Organization.current_id
  end
end
