﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl<BaseForm>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers" %>
<div class="minilista fileUpload" id="fileQueue">
    <h5>Documentos y/o comprobantes</h5>

    <% if (Model.Archivos != null && Model.Archivos.Length > 0) { %>
        <% for(int i = 0; i < Model.Archivos.Length; i++) { %>
	        <div class="sublista" id="archivo_<%=Html.Encode(Model.Archivos[i].Id) %>">
	            <h6>
                    <%=Html.ActionLink(Html.Encode(Model.Archivos[i].Nombre), "Show", "Archivo", new { id = Model.Archivos[i].Id }, null) %>
	                <!-- <%=Html.ActionLinkForAreas<ArchivoController>(x => x.Show(Model.Archivos[i].Id), Html.Encode(Model.Archivos[i].Nombre))%> -->
	                <%=Html.Hidden("Archivo[" + i + "].Id", Model.Archivos[i].Id)%>
	            </h6>
			</div><!--end sublista-->
        <% } %>
    <% } else { %>
        <div class="sublista" id="archivoEmptyListForm">
            <h6><span>No hay archivos adjuntos</span></h6>
		</div><!--end elementodescripcion-->
    <% } %>
	
</div><!--end minilista-->


