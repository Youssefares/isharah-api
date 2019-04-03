class PaginatedSerializableService
  def initialize(records:, serializer_klass:, serializer_options: {},
                 page:, per_page:)
    @records = records
    @page = page
    @per_page = per_page
    @serializer_klass = serializer_klass
    @serializer_options = serializer_options
  end

  def build_hash
    @records = @records.paginate(page: @page, per_page: @per_page)
    records_hash = @serializer_klass.new(
      @records, @serializer_options
    ).serializable_hash
    records_hash.merge(
      page_meta: {
        # .size over .count: https://medium.com/@craigsheen/count-vs-length-in-rails-4308e83f6292
        total_count: @records.size,
        total_pages: (@records.size / @per_page.to_f).ceil
      }
    )
  end
end
