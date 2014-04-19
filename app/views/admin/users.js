$('#users').html("<%= escape_javascript render(:file => 'admin/users', :formats => [:html]) %>");
