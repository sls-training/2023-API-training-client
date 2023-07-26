# frozen_string_literal: true

module Paginatable
  def pagination_links(link_header_value, base:)
    return {} if link_header_value.blank?

    LinkHeaderParser.parse(link_header_value, base:)
      .group_by_relation_type
      .slice(:first, :last, :prev, :next)
      .transform_values { |a| a.first&.target_uri }
  end
end
