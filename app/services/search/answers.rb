module Services
  module Search
    class Answers < Base

      private

      def search_klass
        Answer
      end

      def search_conditions(params)
        {
          body: params[:body].presence,
          author: params[:author].presence,
        }
      end

    end
  end
end
