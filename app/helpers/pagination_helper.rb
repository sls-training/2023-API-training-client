# frozen_string_literal: true

module PaginationHelper
  def pagination_entires_info(**metadata)
    total = metadata[:total]
    page = metadata[:page]
    per = metadata[:per]

    first_idx_in_page = total.positive? ? 1 + page.pred * per : 0
    last_idx_in_page = (first_idx_in_page + per.pred).then { |n| n > total ? total : n }

    "Displaying items #{first_idx_in_page} - #{last_idx_in_page} of #{total} in total"
  end
end
