<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl<ArticuloForm>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models"%>

$('#Subdisciplina').html('');

<% foreach (var subdisciplina in Model.Subdisciplinas) { %>
    var option = document.createElement("option");
    option.text = '<%= subdisciplina.Nombre%>';
    option.value = <%= subdisciplina.Id%>;
    $('#Subdisciplina')[0].options.add(option);
<% } %>