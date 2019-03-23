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
    records_count = @records.count
    records_hash = @serializer_klass.new(
      @records, @serializer_options
    ).serializable_hash
    records_hash.merge(
      page_meta: {
        total_count: records_count,
        total_pages: (records_count / @per_page.to_f).ceil
      }
    )
  end
end
