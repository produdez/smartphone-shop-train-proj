$(function(){
  var $check_boxes = $('input[name="phone_check_box_id"]')
  var $delete_button = $('#delete-selected')

  $delete_button.on('click', function(){
    var checked_indexes = get_checked_phone_index($check_boxes)

    if(empty_selection(checked_indexes)) return
    if(!confirm('Confirming delete request!')) return

    data_json = {ids: checked_indexes}
    Rails.ajax({
      type: 'post',
      url: 'phones/delete_selected',
      data: new URLSearchParams(data_json).toString(),
      success: function(result){
        if(result.success){
          alert_n_reload(result.message)
        }else{
          alert_n_reload(result.error)
        }
      },
      error: function(){
        alert_n_reload('Request failed')
      }
    })
  })
})

function empty_selection(checked_indexes){
  var empty = checked_indexes.length == 0
  if(empty) window.alert('Please select something first!')
  return empty
}

function alert_n_reload(alert){
  if(!window.alert(alert)){window.location.reload()}
}

function get_checked_phone_index(check_boxes){
  var checked_indexes = []
  check_boxes.each(function(){
    if (this.checked === true) checked_indexes.push(this.value)
  })
  return checked_indexes
}
