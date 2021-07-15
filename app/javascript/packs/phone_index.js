console.log('Loaded phone_index.js')

$(function(){
    var $check_boxes = $('input[name="phone_check_box_id"]')
    var $delete_button = $('#delete-selected')

    $delete_button.on('click', function(){
      var checked_indexes = get_checked_phone_index($check_boxes)
      console.log('Check count: ', $check_boxes.length);
      console.log('Checked indexes: ', checked_indexes);

      if(empty_selection(checked_indexes)) return;
      if(!request_confirmed('Confirming delete request!')) return;

      data_json = {ids: checked_indexes}
      Rails.ajax({
        type: "post",
        url: "phones/delete_selected",
        data: new URLSearchParams(data_json).toString(),
        success: function(result){
          if(result.success){
            log_alert_reload('Server operation successful', result, result.message)
          }else{
            log_alert_reload('Server operation failed', result, result.error)
          }
        },
        error: function(){
          log_alert_reload('Failed: ', 'Request failed', 'Request failed')
        }
      })
    })
});

function request_confirmed(message){
  return confirm(message);
}
function empty_selection(checked_indexes){
  var empty = checked_indexes.length == 0
  if(empty) window.alert('Please select something first!')
  return empty;
}

function log_alert_reload(prepend, result, alert){
  console.log(prepend, result)
  if(!window.alert(alert)){window.location.reload();}
}
function get_checked_phone_index(check_boxes){
  var checked_indexes = []
  check_boxes.each(function(){
    if (this.checked === true) checked_indexes.push(this.value);
  })
  return checked_indexes
}
