

console.log('Loaded phone_index.js')


$(function(){
    $('#shit-button').on('click', function(){
      console.log('button clicked');
    });

    $('#phone_model_id').on('change', function(){
        console.log('Select value: ', $(this).children("option:selected").val());
        $(this).val(2)
        console.log('Select value: ', $(this).children("option:selected").val());

    });

    //! real
    var $check_boxes = $('input[name="phone_check_box_id"]')
    var $delete_button = $('#delete-selected')

    $delete_button.on('click', function(){
      console.log('Check count: ', $check_boxes.length);
      var checked_indexes = get_checked_phone_index($check_boxes)
      console.log('Checked indexes: ', checked_indexes);
      if(checked_indexes.length == 0){
        alert('Dint select anything');
        return
      }
      // TODO: make ajax request to delete
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
