# frozen_string_literal: true

module Officer
  module Outlets
    # Taxonomies
    class Taxonomies < Main
      # grab all taxonomies
      def grab_all
        return false, { message: t('officer.invalid_params') } if \
          params[:outlet_id].blank?

        return false, { message: I18n.t('officer.not_found', r: 'Taxonomies') } \
          unless taxonomies

        [true, taxonomies]
      rescue StandardError => e
        [false, e.message]
      end

      # grap one taxonomy
      def grab_one
        return false, { message: t('officer.invalid_params') } if \
          params[:id].blank?

        return false, { message: I18n.t('officer.not_found', r: 'Taxonomy') } \
          unless taxonomy

        [true, with_trees]
      rescue StandardError => e
        [false, e.message]
      end

      private

      def taxonomies
        ::Taxonomy.where(outlet_id: outlet_id)
      end

      def taxonomy
        ::Taxonomy.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        false
      end

      def with_trees
        {
          message: 'success',
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
            childrens: json_tree(sub_nodes).compact
          }
        end
      end
    end
  end
end
