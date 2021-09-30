module Services
  module Search
    class Comments < Base

      private

      def search_klass
        Comment
      end

      def search_conditions(params)
        {
          text: params[:text].presence,
          author: params[:author].presence,
        }
      end

    end
  end
end
