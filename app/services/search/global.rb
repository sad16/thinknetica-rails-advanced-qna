module Services
  module Search
    class Global < Base

      private

      def search_klass
        ThinkingSphinx
      end

    end
  end
end
