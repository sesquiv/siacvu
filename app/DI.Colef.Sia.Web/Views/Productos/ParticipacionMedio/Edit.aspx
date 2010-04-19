﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" 
    Inherits="System.Web.Mvc.ViewPage<GenericViewData<ParticipacionMedioForm>>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Core"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Helpers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Productos"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Extensions"%>
<%@ Import Namespace="DI.Colef.Sia.Web.Controllers" %>

<asp:Content ID="titleContent" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    <h2>
        <%=Html.ProductoEditTitle(TipoProductoEnum.ParticipacionMedio) %>
    </h2>
</asp:Content>

<asp:Content ID="introductionContent" ContentPlaceHolderID="IntroduccionPlaceHolder" runat="server">
	<div id="introduccion">
		<p>
            <%=Html.ProductoEditMessage(TipoProductoEnum.ParticipacionMedio) %>
		</p>
	</div><!--end introduccion-->	
</asp:Content>

<asp:Content ID="sidebarContent" ContentPlaceHolderID="SidebarContentPlaceHolder" runat="server">
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <div id="textos">
    
	    <% Html.RenderPartial("_Message"); %>

        <% if(User.IsInRole("Investigadores")){ %>
			<% Html.RenderPartial("_FirmaMessage", Model.Form); %>
        <% } %>
	    
	    <div id="forma">

            <% using (Html.BeginForm("Update", "ParticipacionMedio", FormMethod.Post, new { @class = "remote" })){ %>
		        <%=Html.AntiForgeryToken()%>
                <%=Html.Hidden("Id", Model.Form.Id)%>
                <%=Html.Hidden("Contexto", "participacionMedio", new { url = Url.Action("Glosario") })%>
                
                <h4>Datos de la participaci&oacute;n en medio</h4>
                <% Html.RenderPartial("_DatosParticipacionMedio", Model.Form); %>
        				
                <p class="submit">
                    <%=Html.SubmitButton("Guardar", "Guardar cambios")%> &oacute; <%=Html.ActionLink<ParticipacionMedioController>(x => x.Index(), "Regresar", new { id = "regresar" })%>
                </p>
            <% } %>
	    </div><!--end forma-->	

	        <% if(User.IsInRole("DGAA")){ %>    
            	<% Html.RenderPartial("_FirmaForm", new FirmaForm{Id = Model.Form.Id, IdName = "ArticuloId", Controller = "Articulo", TipoProducto = 1}); %>
            <% } %>
                		
    </div><!--end textos-->
    
<script type="text/javascript">
    $(document).ready(function() {
        setupDocument();
        participacionMedioSetup();
    });
</script>
</asp:Content>