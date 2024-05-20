<% @Language=JScript %>
<%
if (Request.ServerVariables('AUTH_TYPE') != 'Basic') {
  Response.Redirect('basic/');
}

Response.Addheader('X-User', Request.ServerVariables('AUTH_USER'))
%>
