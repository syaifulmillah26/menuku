# frozen_string_literal: true

module Officer
  module Outlets
    # Taxonomies
    class Taxons < Main
      def grab_all
        return false, { message: t('officer.invalid_params') } \
          unless check_params

        return false, { message: t('officer.taxonomies.not_found') } \
          unless taxonomy

        [true, with_trees]
      rescue StandardError => e
        [false, e.message]
      end

      def taxonomy
        ::Taxonomy.find_by(id: params[:taxonomy_id])
      end

      def with_trees
        data = {}
        data[:message] = 'success'
        data[:data] = taxonomy.as_json
        data[:data][:taxons] = json_tree(taxonomy&.taxons&.arrange)

        data
      end

      def json_tree(nodes)
        nodes.collect do |node, sub_nodes|
          {
            id: node.id,
            taxonomy_id: node.taxonomy_id,
            name: node.name,
            children: json_tree(sub_nodes).compact
          }
        end
      end

      def check_params
        return false if \
          params[:taxonomy_id].blank?

        true
      end
    end
  end
end
