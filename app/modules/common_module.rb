module CommonModule
    extend self

    def define_query_parameters(query_parameters)
        relation = query_parameters.key?('with') ? query_parameters['with'] : false
        page = query_parameters.key?('page') ? query_parameters['page'].to_i : false
        limit = query_parameters.key?('page_size') ? query_parameters['page_size'].to_i : false
        sort = query_parameters.key?('sort') ? query_parameters['sort'] : false

        { 'relation' => relation, 'page' => page, 'limit' => limit, 'sort' => sort }
    end

    def define_type_ordering(sort)
        isAscending = sort.include?('-')
        property = isAscending ? sort.split('-').pop() : sort
        { property => isAscending ? -1 : 1 }
    end

end