$('#pending_posts').empty()
$('#pending_posts').append("<%= escape_javascript render(:file => 'admin/pending_posts', :formats => [:html]) %>");