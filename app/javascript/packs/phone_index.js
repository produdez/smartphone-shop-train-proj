$(function(){
  var $check_boxes = $('input[name="phone_check_box_id"]')
  var $delete_button = $('#delete-selected')
  var $unavailable_button = $('#unavailable-selected')

  $delete_button.on('click', function(){
    data_json = check_selected_and_parse_data($check_boxes, 'delete')
    post_ajax_request(data_json, 'phones/delete_selected')
  })

  $unavailable_button.on('click', function(){
    data_json = check_selected_and_parse_data($check_boxes, '"Set Unavailable"')
    post_ajax_request(data_json, 'phones/unavailable_selected')
  })
})

function check_selected_and_parse_data(check_boxes, request_name){
  var checked_indexes = get_checked_phone_index(check_boxes)

  if(empty_selection(checked_indexes)) return
  if(!confirm(`Confirming ${request_name} request!`)) return
  return {ids: checked_indexes}
}

function post_ajax_request(data, url){
  Rails.ajax({
    type: 'post',
    url: url,
    data: new URLSearchParams(data).toString(),
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
}

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
