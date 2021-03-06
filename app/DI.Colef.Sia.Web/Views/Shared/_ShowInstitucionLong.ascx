﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl<BaseForm>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Helpers"%>
<% if(!Model.IsShowForm){ %>
    <p>
        <label><%= Html.Encode(Model.InstitucionLabel) %></label>
        <%=Html.TextBox("InstitucionNombre", Model.InstitucionNombre,
                new { @class = "autocomplete buscar-requerido", url = Url.Action("Search", "Institucion"), maxlength = 100 })%>
        <%=Html.Hidden("InstitucionId", Model.InstitucionId, new { rel = "#InstitucionNombre", url = Url.Action("ChangeInstitucion") })%>
        <span class="cvu"></span>
    <%if (!Model.InstitucionExists && !String.IsNullOrEmpty(Model.InstitucionNombre)) { %>
        <span class="field-alert">Esta instituci&oacute;n no esta registrada en el cat&aacute;logo</span>
    <% } %>
    </p>
<% } else { %>
    <p>
        <label><%= Html.Encode(Model.InstitucionLabel) %></label>
        <span class="valor"><%= Html.Encode(Model.InstitucionNombre)%>&nbsp;</span>
    </p>
<% } %>
<p>
    <label>Ciudad</label>
    <span id="span_ciudad" class="valor"><%= Html.Encode(Model.InstitucionCiudad)%>&nbsp;</span>
</p>
<p>
    <label>Estado</label>
    <span id="span_estado" class="valor"><%= Html.Encode(Model.InstitucionEstadoPaisNombre)%>&nbsp;</span>
</p>
<p>
    <label>Pa&iacute;s</label>
    <span id="span_pais" class="valor"><%= Html.Encode(Model.InstitucionPaisNombre)%>&nbsp;</span>
</p>
<p>
    <label>Tipo de instituci&oacute;n</label>
    <span id="span_tipoinstitucion" class="valor"><%= HumanizeHelper.TipoInstitucion(Model.InstitucionTipoInstitucionNombre)%>&nbsp;</span>
</p>