setup = ->
  $('[data-success-use="assign_to"]').click ->
    $('#assign-to').on("ajax:success", (e, data, status, xhr) ->
      $('#assign-to-target').text(data.assign_to)
      $('.popover').hide()
    ).on "ajax:error", (xhr, status, error) ->
      $('#assign-to-message').append('The attendant was not assigned')

  $('.groups').on 'click', '#add-client-button', ->
    email = $('#member_id').val()
    $.post($(this).data('url'),
      { email: email }, 'json')
        .success (data) ->
          $('.flashes .alert-success').show().html(data)
          setTimeout ->
            location.reload()
          , 1600
        .fail (xhr, data) ->
          $('.flashes .alert-danger').show().html(xhr.responseText)
    false

  $('.groups').on 'click', '[data-add-channel-button]', ->
    channelId = $('.channel-add-field').val()
    $.post($(this).data('url'),
      { channel_id: channelId }, 'json')
        .success ->
          location.reload()
    false

  $('.groups').on 'ajax:success', '.delete-user', (e, data) ->
    $("[data-user-id='#{data.id}']").addClass('inactive')

$(document).ready setup
