# frozen_string_literal: true

module Officer
  module Outlets
    # Taxonomies
    class Taxonomies < Main
      # grab all taxonomies
      def grab_all
        return false, { message: t('officer.invalid_params') } \
          unless check_params

        return false, { message: I18n.t('officer.not_found', r: 'Taxonomies') } \
          unless taxonomies

        [true, taxonomies]
      rescue StandardError => e
        [false, e.message]
      end

      # grap one taxonomy
      def grab_one
        return false, { message: t('officer.invalid_params') } \
          unless check_params

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
            permalink: node.permalink,
            children: json_tree(sub_nodes).compact
          }
        end
      end

      # params

      def grab_all_params
        return false if params[:outlet_id].blank?

        true
      end

      def grab_one_params
        return false if params[:id].blank?

        true
      end
    end
  end
end
