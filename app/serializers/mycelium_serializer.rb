class MyceliumSerializer < Blueprinter::Base
  identifier :id
  field :name

  view :card do
    field :type
    field :species do |object|
      I18n.t("mycelium.species.#{object.species}")
    end
    field :image_url
  end

  view :show do
    field :type
    field :species do |object|
      I18n.t("mycelium.species.#{object.species}")
    end
    field :generation
    field :external_provider
    field :substrate do |object|
      I18n.t("mycelium.substrates.#{object.substrate}")
    end
    field :container do |object|
      I18n.t("mycelium.containers.#{object.container}")
    end
    field :strain_description
    field :shelf_time
    field :image_url
    field :weight
    field :prefix
    field :created_at
    field :updated_at
    field :organization_id
    field :flush
    association :strain_source, blueprint: MyceliumSerializer
    association :room, blueprint: RoomSerializer
  end

end


