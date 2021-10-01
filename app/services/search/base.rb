module Services
  module Search
    class Base < ApplicationService
      class Error < StandardError; end
      class EmptySearchError < Error; end

      def call(params)
        search(params.to_h.deep_symbolize_keys)
      end

      private

      def search(params)
        search_options = search_options(params)
        validate_search_options(search_options)
        search_klass.search(*search_options)
      end

      def search_options(params)
        [
          params[:global].presence,
          { conditions: search_conditions(params).compact }
        ]
      end

      def validate_search_options(search_options)
        raise EmptySearchError if search_options[0].nil? && search_options[1][:conditions].blank?
      end

      def search_klass
        raise NotImplementedError
      end

      def search_conditions(params)
        {}
      end
    end
  end
end
