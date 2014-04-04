$('#active_posts').empty()
$('#active_posts').append("<%= escape_javascript render(:file => 'admin/active_posts', :formats => [:html]) %>");