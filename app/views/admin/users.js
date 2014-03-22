$('#users').empty()
$('#users').append("<%= escape_javascript render(:file => 'admin/users', :formats => [:html]) %>");