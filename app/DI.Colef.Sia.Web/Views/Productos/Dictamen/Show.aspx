﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true"
    Inherits="System.Web.Mvc.ViewPage<GenericViewData<DictamenForm>>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Helpers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Core"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Productos"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Extensions" %>
<%@ Import Namespace="DI.Colef.Sia.Web.Controllers" %>

<asp:Content ID="titleContent" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    <h2>
        <%=Html.ProductoShowTitle(TipoProductoEnum.Dictamen) %>
    </h2>
</asp:Content>

<asp:Content ID="introductionContent" ContentPlaceHolderID="IntroduccionPlaceHolder" runat="server">
    <div id="introduccion">
        <p>
            <%=Html.ProductoShowMessage(TipoProductoEnum.Dictamen) %>
		</p>
    </div><!--end introduccion-->
</asp:Content>

<asp:Content ID="sidebarContent" ContentPlaceHolderID="SidebarContentPlaceHolder" runat="server">
    <div id="barra">
        <div id="asistente">
            <h3>Asistente de secci&oacute;n</h3>
            <% Html.RenderPartial("_ShowSidebar"); %>
        </div><!--end asistente-->

    </div><!--end barra-->
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <div id="textos">

        <div id="forma">
            <div id="campos">
                <%--<h4>Datos del investigador</h4>
	            <p>
                    <label>Nombre</label>
                    <span class="valor"><%= Html.Encode(Model.Form.InvestigadorNombre)%>&nbsp;</span>
                </p>
	            <p>
                    <label>Departamento</label>
                    <span class="valor"><%= Html.Encode(Model.Form.DepartamentoNombre)%>&nbsp;</span>
                </p>
                <p>
                    <label>Sede</label>
                    <span class="valor"><%= Html.Encode(Model.Form.SedeNombre)%>&nbsp;</span>
                </p>--%>
                <h4>Datos del dictamen</h4>
                <p>
	                <label>
                        T&iacute;tulo del producto dictaminado</label>
	                <span class="valor"><%= Html.Encode(Model.Form.Nombre)%>&nbsp;</span>
                </p>
                <p>
	                <label>Fecha de dictamen</label>
	                <span class="valor"><%= Html.Encode(Model.Form.FechaDictamen)%>&nbsp;</span>
	                </span><span>Formato (dd/mm/aaaa)</span>
                </p>
                <p>
	                <label>Producto dictaminado</label>
	                <span class="valor"><%= Html.Encode(Model.Form.TipoDictamenNombre)%>&nbsp;</span>
                </p>
                
                <% if (Model.Form.TipoDictamenNombre.Contains("Artículo")){ %>
                    <% Html.RenderPartial("_ShowRevista", Model.Form.ShowFields); %>
                <% } %>
                
                <% if (Model.Form.TipoDictamenNombre.Contains("Libro")){ %>
                    <% Html.RenderPartial("_ShowEditorial", new EditorialForm { Editoriales = Model.Form.EditorialDictamenes, ModelId = Model.Form.Id }); %>
                <% } %>
                
                <% if(Model.Form.TipoDictamenNombre.Contains("Proyecto")){ %>
                    <p>
	                    <label>Tipo de proyecto</label>
	                    <span class="valor"><%= Html.Encode(Model.Form.FondoConacytNombre)%>&nbsp;</span>
                    </p>
                <% } %>
                
                <% Html.RenderPartial("_ShowArchivo", Model.Form); %>
                
                <p class="submit">
                    <%=Html.ActionLink<DictamenController>(x => x.Index(), "Regresar") %>
                </p>
            </div><!--end campos-->
        </div><!--end lista-->

    </div><!--end textos-->
    
<script type="text/javascript">
    $(document).ready(function() {
        setupDocument();
    });
</script>
</asp:Content>