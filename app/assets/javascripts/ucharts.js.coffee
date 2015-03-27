$.fn.uchart = (options, data=null)->
  $(this).each ->
    _options = $.extend({}, $(this).data(), options)
    _data = data || $(this).data('data')
    chart = new Chart($(this).get(0).getContext('2d'))[_options.chart](_data, _options)
    $(this).data('chart', chart)
  $(this)
