﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl<CoautorForm>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Extensions"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models"%>
<div class="minilista" id="coautorexternoList">

    <% if (Model.CoautoresExternos != null && Model.CoautoresExternos.Length > 0) { %>
        <% for(int i = 0; i < Model.CoautoresExternos.Length; i++) { %>
	        <div class="sublista" id="coautorexterno_<%=Html.Encode(Model.CoautoresExternos[i].InvestigadorExternoId) %>">
	            <h6>
	                <a href="<%=Url.Action("deletecoautorexterno", null, new{ id = Model.ModelId, investigadorExternoId = Model.CoautoresExternos[i].InvestigadorExternoId}) %>" class="remote delete"><img src="<%=ResolveUrl("~/Content/Images/eliminar-icon.png") %>" /></a>
	                <%=Html.Encode(Model.CoautoresExternos[i].NombreCompleto)%>
	                <%=Html.Hidden("CoautorExterno[" + i + "].InvestigadorExternoId", Model.CoautoresExternos[i].InvestigadorExternoId)%>
	                <% if (Model.CoautoresExternos[i].InstitucionId != 0) {%>
	                    <span>
                            Instituci&oacute;n <%=Html.Encode(Model.CoautoresExternos[i].InstitucionNombre)%>
                            <%=Html.Hidden("CoautorExterno[" + i + "].InstitucionId", Model.CoautoresExternos[i].InstitucionId)%>
                        </span>
                    <% } %>
	            </h6>
			</div><!--end sublista-->
        <% } %>
    <% } else { %>
        <div class="sublista" id="coautorexternoEmptyListForm">
            <h6><span>No hay investigadores externos registrados</span></h6>
		</div><!--end elementodescripcion-->
    <% } %>
	
</div><!--end minilista-->
