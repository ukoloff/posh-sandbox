<% @Language=JScript %>
<%
if (Request.ServerVariables('AUTH_TYPE') != 'Basic') {
  Response.Redirect('basic/');
}

var params = {}
var items = [Request.QueryString, Request.Form]
for (var i = 0; i < items.length; i++) {
  var item = items[i]
  for (var E = new Enumerator(item); !E.atEnd(); E.moveNext()) {
    var k = E.item()
    params[k] = item(k)
  }
}

var json = ''
for (var k in params) {
  if (json) json += ",\n"
  json += jsQuote(k) + ": " + jsQuote(params[k])
}

json = "{" + json + "}"

var z = Ajax()
z.open('POST', 'https://nc.ekb.ru', false)
z.send(json)
Response.Status = z.status + ' ' + z.statusText
Response.ContentType = z.getResponseHeader('Content-Type')
Response.Write(z.ResponseBody)

function jsQuote(s) {
  return '"' + String(s)
    .replace(/\\/g, '\\')
    .replace(/\n/g, "\\n")
    .replace(/\r/g, "\\r")
    .replace(/"/g, '\\\"')
    + '"'
}

function Ajax() {
  var e
  try { return new XMLHttpRequest() } catch (e) { }
  try { return Server.CreateObject("MSXML2.ServerXMLHTTP") } catch (e) { }
  try { return Server.CreateObject("Msxml2.XMLHTTP") } catch (e) { }
  try { return Server.CreateObject("Microsoft.XMLHTTP") } catch (e) { }
}
%>
