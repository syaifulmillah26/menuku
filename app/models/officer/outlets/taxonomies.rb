# frozen_string_literal: true

module Officer
  module Outlets
    # Taxonomies
    class Taxonomies < Main
      # grap one taxonomy
      def grab_one
        return error_message(I18n.t('officer.not_found', r: 'Taxonomy')) \
          unless taxonomy

        [200, with_trees]
      end

      private

      def taxonomies
        ::Taxonomy.where(outlet_id: outlet_id)
      end

      def taxonomy
        ::Taxonomy.find_by(id: params[:id], outlet_id: outlet_id)
      end

      def with_trees
        {
          message: t('officer.success'),
          data: taxonomy.as_json.merge(
            taxons: json_tree(taxonomy&.taxons&.arrange)
          )
        }
      end

      def json_tree(nodes)
        nodes.collect do |node, sub_nodes|
          {
            id: node.id, taxonomy_id: node.taxonomy_id,
            name: node.name, permalink: node.permalink,
            children: json_tree(sub_nodes).compact
          }
        end
      end
    end
  end
end
