module Services
  module Search
    class Questions < Base

      private

      def search_klass
        Question
      end

      def search_conditions(params)
        {
          title: params[:title].presence,
          body: params[:body].presence,
          author: params[:author].presence,
        }
      end

    end
  end
end
