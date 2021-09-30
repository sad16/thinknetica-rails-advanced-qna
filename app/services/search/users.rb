module Services
  module Search
    class Users < Base

      private

      def search_klass
        User
      end

      def search_conditions(params)
        {
          email: params[:email].presence,
        }
      end

    end
  end
end
