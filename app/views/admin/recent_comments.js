$('#recent_comments').empty()
$('#recent_comments').append("<%= escape_javascript render(:file => 'admin/recent_comments', :formats => [:html]) %>");