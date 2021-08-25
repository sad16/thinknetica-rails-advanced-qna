module ControllerHelper
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def serialize(object)
    ActiveModelSerializers::SerializableResource.new(object)
  end
end
