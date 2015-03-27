$.fn.select2Ajax = (options) ->
  defaults =
    placeholder: $(this).data('placeholder') || 'Busca',
    minimumInputLength: $(this).data('select2-min-input') || 2,
    initSelection: (element, callback) =>
      id=$(element).val();
      if id!=""
        $.ajax("#{$(element).data('url')}/#{id}",
          dataType: "json",
          data: { format: 'json' }
        ).done (data) =>
          if data[$(this).data('select2-title')]
            callback
              text: data[$(this).data('select2-title')],
              id: data[$(this).data('select2-id')]
    ,
    ajax:
      url: $(this).data('url'),
      dataType: 'json',
      data: (term, page) ->
        {
          format: 'json',
          filter_text: term
        }
      ,
      results: (data, page) =>
        results = [];
        $.each data, (index, item) =>
          results.push
            id: item[$(this).data('select2-id')],
            text: item[$(this).data('select2-title')]
        { results: results }
  options = $.extend({}, defaults, options)
  $(this).select2 options
