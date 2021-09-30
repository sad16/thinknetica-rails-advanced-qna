module Search
  class GlobalSerializer < ApplicationSerializer
    attributes :wrapper

    def wrapper
      {
        object.class.name.downcase => object
      }
    end
  end
end
