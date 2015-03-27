setup = ->
  $('[data-toggle="popover"][data-content-target]').each ->
    $(this).popover
      content: ->
        $($(this).data('content-target')).html()
  $('.ticket-page').on 'click', '.ticket-popovers [type=submit]', ->
    $(this).button('loading')

  $('.ticket-page .actions [data-remote]').on 'ajax:before', ->
    $(this).button('loading')
  .on 'ajax:success', ->
    $(this).button('complete')
    location.reload()
  .on 'ajax:error', ->
    $(this).button('reset')


  $('.ticket-page').on 'ajax:success', '.ticket-popovers form', (ajax)->
    $triggerer = $("[data-content-target='#{$(this).data('reverse-id')}']")
    if $triggerer.data('success-use')
      $.ajax
        url: $(this).attr('action'),
        dataType: 'json',
        success: (data) =>
          $triggerer.text(data[$triggerer.data('success-use')])
          $triggerer.popover('hide')
    else
      $triggerer.popover('hide')
    true
  .on 'ajax:complete', '.ticket-popovers form', ->
    $(this).find('[type=submit]').button('reset')

  $('.ticket-page').on 'ajax:success', '[data-reverse-id="#cancel-popover"]', ->
    $('[data-content-target="#cancel-popover"]').button('complete')
    location.reload()
  .on 'ajax:error', '[data-reverse-id="#cancel-popover"]', (xhr, data) ->
    $(this).prepend("<div class='alert alert-danger'>#{data.responseText}</div>")

$(document).ready setup
