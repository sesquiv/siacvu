﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true"
    Inherits="System.Web.Mvc.ViewPage<GenericViewData<LibroForm>>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Core"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Helpers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Productos"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Extensions" %>
<%@ Import Namespace="DI.Colef.Sia.Web.Controllers" %>

<asp:Content ID="titleContent" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    <h2>
        <%=Html.ProductoEditTitle(TipoProductoEnum.Libro) %>
    </h2>
</asp:Content>

<asp:Content ID="introductionContent" ContentPlaceHolderID="IntroduccionPlaceHolder" runat="server">
    <div id="introduccion">
        <p>
            <%=Html.ProductoEditMessage(TipoProductoEnum.Libro) %>
        </p>
    </div><!--end introduccion-->
</asp:Content>

<asp:Content ID="sidebarContent" ContentPlaceHolderID="SidebarContentPlaceHolder" runat="server">
    <div id="barra">
        <div id="asistente">
            <% if(User.IsInRole("Investigadores")){ %>
                <% if(Model.Form.FirmaAceptacion2 == 2){ %>
                    <h3>&Aacute;rea de validaci&oacute;n de producto</h3>
                    <p>Motivo del rechazo: <%=Html.Encode(Model.Form.FirmaDescripcion)%></p>
                <% } %>
            <% } %>
	        <% if(User.IsInRole("DGAA")){ %>
	            <h3>&Aacute;rea de validaci&oacute;n de producto</h3>
	            <% Html.RenderPartial("_FirmaForm", new FirmaForm{Id = Model.Form.Id, IdName = "LibroId", Controller = "Libro", TipoProducto = 7}); %>
	        <% } %>
            <h3>Asistente de secci&oacute;n</h3>
            <% Html.RenderPartial("_NewSidebar"); %>
        </div><!--end asistente-->
    </div><!--end barra-->
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div id="textos">
	
    <% Html.RenderPartial("_Message"); %>    
    <div id="forma">

        <% using (Html.BeginForm("Update", "Libro", FormMethod.Post, new { @class = "remote" })){ %>
            <%=Html.AntiForgeryToken() %>
            <%=Html.Hidden("Id", Model.Form.Id) %>
            <%=Html.Hidden("Contexto", "libro", new { url = Url.Action("Glosario") })%>

            <h4>Datos de la publicaci&oacute;n</h4>
            <% Html.RenderPartial("_DatosPublicacion", Model.Form); %>
            
            <h4>
            <a href="#coautores_area" class="collapsable <%=Html.CollapsePanelClass(Model.Form.CoautorExternoLibros.Length + Model.Form.CoautorInternoLibros.Length) %>">
                <span class="ui-icon ui-icon-circle-arrow-s"></span>
                <span id="coautores" class="titulovalor"><%=Model.Form.TipoProducto == 2 ? "Coodinadores" : Model.Form.TipoProducto == 3 ? "Compiladores" : "Coautores" %></span>
                del libro <span>
                    <%=Html.Encode(Model.Form.CoautorExternoLibros.Length + Model.Form.CoautorInternoLibros.Length)%>
                    coautor(es) </span><span class="cvu"></span></a>
            </h4>
            <span id="coautores_area">
            <% Html.RenderPartial("_AddButtons", new ShowFieldsForm { ModelId = Model.Form.Id, CheckboxName = "CoautorSeOrdenaAlfabeticamente", CheckboxValue = Model.Form.CoautorSeOrdenaAlfabeticamente, Rel = "NewCoautorInternoLink, NewCoautorExternoLink", SubFormName = "coautor", UrlActionExterno = "NewCoautorExterno", UrlActionInterno = "NewCoautorInterno", Link1Id = "NewCoautorInternoLink", Link2Id = "NewCoautorExternoLink" }); %>
            <% Html.RenderPartial("_EditCoautorInterno", new CoautorForm { CoautoresInternos = Model.Form.CoautorInternoLibros, ModelId = Model.Form.Id, CoautorSeOrdenaAlfabeticamente = Model.Form.CoautorSeOrdenaAlfabeticamente }); %>
            <% Html.RenderPartial("_EditCoautorExterno", new CoautorForm { CoautoresExternos = Model.Form.CoautorExternoLibros, ModelId = Model.Form.Id, CoautorSeOrdenaAlfabeticamente = Model.Form.CoautorSeOrdenaAlfabeticamente }); %>
            <% Html.RenderPartial("_CoautorEmptyListMessage", new CoautorForm { CoautoresExternos = Model.Form.CoautorExternoLibros, CoautoresInternos = Model.Form.CoautorInternoLibros }); %>

            <% Html.RenderPartial("_AutorEntry", Model.Form); %>
            </span>
            
            <% Html.RenderPartial("_ShowEstadoProducto", 
                new ShowFieldsForm { EstadosProductos = Model.Form.EstadosProductos, FechaAceptacion = Model.Form.FechaAceptacion, 
                    FechaPublicacion = Model.Form.FechaPublicacion, IsShowForm = false, ModelId = Model.Form.Id, 
                    ComprobanteAceptadoId = Model.Form.ComprobanteAceptadoId, ComprobanteAceptadoNombre = Model.Form.ComprobanteAceptadoNombre}); %>
            
            <% Html.RenderPartial("_EditEditorial", Model.Form); %>
            
            <div class="EstatusPublicado">
                <% Html.RenderPartial("_ReferenciaBibliografica", Model.Form); %>
            </div>
            <div id="obra_field">
            <p>
                <label>Libro publicado</label>
                <span id="span_comprobante_documento" class="valor">
                    <%if(!String.IsNullOrEmpty(Model.Form.ComprobanteLibroNombre)) { %> 
	                    <%=Html.ActionLink<ArchivoController>(x => x.Show(Model.Form.ComprobanteLibroId), Model.Form.ComprobanteLibroNombre, new { target = "_blank" })%> 
	                <% } else { %>
	                    &nbsp;
	                <% } %>
                </span><br />
            </p>
            <div style="padding: 0 0 10px 20px">
                <input type="file" name="ComprobanteLibro_DocumentoProbatorio" id="ComprobanteLibro_DocumentoProbatorio" class="fileUpload"/>
            </div>
            <div id="Comprobante_FileQueue" style="display:none;" rel="#span_comprobante_documento"></div>
            </div>
            <% Html.RenderPartial("_DatosFinal", Model.Form); %>
            
            <% Html.RenderPartial("_ProgressBar"); %>
			
            <p class="submit">
                <%=Html.SubmitButton("Guardar", "Guardar cambios") %> &oacute; <%=Html.ActionLink<LibroController>(x => x.Index(), "Regresar", new { id = "regresar" })%>
            </p>
        <% } %>
    </div><!--end forma-->
    
</div><!--end textos-->

<script type="text/javascript">
    $(document).ready(function() {
        setupDocument();

        libroSetup();
        setupOrden();

        var auth = "<% = Request.Cookies[FormsAuthentication.FormsCookieName]==null ? string.Empty : Request.Cookies[FormsAuthentication.FormsCookieName].Value %>";
        var uploader = '<%=ResolveUrl("~/Scripts/uploadify.swf") %>';
        var cancelImg = '<%=ResolveUrl("~/Content/Images/eliminar-icon.png") %>';
        var action = '<%=Url.Action("AddFile") %>';

        UploadFile.setup('#Aceptado_DocumentoProbatorio', 'Aceptado_FileQueue',
            uploader, cancelImg, action, auth);
        UploadFile.setup('#ComprobanteLibro_DocumentoProbatorio', 'Comprobante_FileQueue',
            uploader, cancelImg, action, auth);
    });
</script>

</asp:Content>
