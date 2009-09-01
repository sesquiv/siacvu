<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl<ProyectoForm>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Extensions"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models"%>

var cssclass = 'remote';
var rel = '#participanteexternoform';

<% if(Model.Id == 0) { %>
    cssclass = 'local';
    rel = '#ParticipanteExternoProyecto.InvestigadorExternoId';
<% } %>

var html = '
    <% using (Html.BeginForm("AddParticipanteExterno", "Proyecto", FormMethod.Post, new { id = "participanteexternoform" }))
       { %>
    <%=Html.Hidden("ProyectoId", Model.Id)%>
    <% Html.RenderPartial("_NewParticipanteExterno"); %>
    <div class="minilistaboton">
        <p>
            <span>
                <%=Html.SubmitButton("Guardar", "Agregar participante externo", new { rel = "' + rel + '", @class = "' + cssclass + '", @style = "border: 0px none;" })%>
            </span> &oacute; <a href="#" class="cancel minilistacancelar" rel="participanteexterno">Cancelar</a>
        </p>
    </div>
    <% } %>
';

$('#participanteexterno_form').html(html);
$('#participanteexterno_new').hide();
$('#participanteexterno_form').show();
DateTimePicker.setup();
