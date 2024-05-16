<%@ Language=JScript %>
<%
if (Request.ServerVariables('AUTH_TYPE') != 'Basic')
{
  Response.Redirect('basic/');
}

%>
!!!
