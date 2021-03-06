<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true"
    Inherits="System.Web.Mvc.ViewPage<GenericViewData<ArticuloDifusionForm>>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Helpers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Productos"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Extensions" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Core" %>

<asp:Content ID="titleContent" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    <h2>
        <%=Html.ProductoNewTitle(TipoProductoEnum.ArticuloDifusion) %>
	</h2>
</asp:Content>

<asp:Content ID="introductionContent" ContentPlaceHolderID="IntroduccionPlaceHolder" runat="server">
	<div id="introduccion">
	    <p>
            <%=Html.ProductoNewMessage(TipoProductoEnum.ArticuloDifusion) %>
	    </p>
	</div><!--end introduccion-->
</asp:Content>

<asp:Content ID="sidebarContent" ContentPlaceHolderID="SidebarContentPlaceHolder" runat="server">
	<div id="barra">
	    <div id="asistente">
	        <h3>Asistente de secci&oacute;n</h3>
	        <% Html.RenderPartial("_NewSidebar"); %>
	    </div><!--end asistente-->

	</div><!--end barra-->
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
	<div id="textos">
	
	    <% Html.RenderPartial("_Message"); %>    
	    <div id="forma">
	
	        <% using (Html.BeginForm("Create", "ArticuloDifusion", FormMethod.Post, new { @class = "remote" })){ %>
	            <%=Html.AntiForgeryToken() %>
	            <%=Html.Hidden("Id", Model.Form.Id) %>
                <%=Html.Hidden("Contexto", "articuloDifusion", new { url = Url.Action("Glosario") })%>
                
                <h4>Datos de la publicaci&oacute;n</h4>
                <% Html.RenderPartial("_DatosPublicacion", Model.Form); %>
                            
            <h4>
                <a href="#coautores_area" class="collapsable <%=Html.CollapsePanelClass(Model.Form.CoautorExternoArticulos.Length + Model.Form.CoautorInternoArticulos.Length) %>">
                    <span class="ui-icon ui-icon-circle-arrow-s"></span>
                    Coautor(es) <!--del art&iacute;culo de difusi&oacute;n-->
                    <span>
                        <%=Html.Encode(Model.Form.CoautorExternoArticulos.Length + Model.Form.CoautorInternoArticulos.Length)%> coautor(es)
                    </span> 
                    <span class="cvu"></span>
                  </a>
                </h4>
                <span id="coautores_area">
                  <% Html.RenderPartial("_AddButtons", new ShowFieldsForm { ModelId = Model.Form.Id, CheckboxName = "CoautorSeOrdenaAlfabeticamente", CheckboxValue = Model.Form.CoautorSeOrdenaAlfabeticamente, Rel = "NewCoautorInternoLink, NewCoautorExternoLink", SubFormName = "coautor", UrlActionExterno = "NewCoautorExterno", UrlActionInterno = "NewCoautorInterno", Link1Id = "NewCoautorInternoLink", Link2Id = "NewCoautorExternoLink" }); %>
                  <% Html.RenderPartial("_EditCoautorInterno", new CoautorForm { CoautoresInternos = Model.Form.CoautorInternoArticulos, ModelId = Model.Form.Id, CoautorSeOrdenaAlfabeticamente = Model.Form.CoautorSeOrdenaAlfabeticamente }); %>
                  <% Html.RenderPartial("_EditCoautorExterno", new CoautorForm { CoautoresExternos = Model.Form.CoautorExternoArticulos, ModelId = Model.Form.Id, CoautorSeOrdenaAlfabeticamente = Model.Form.CoautorSeOrdenaAlfabeticamente }); %>
                  <% Html.RenderPartial("_CoautorEmptyListMessage", new CoautorForm { CoautoresExternos = Model.Form.CoautorExternoArticulos, CoautoresInternos = Model.Form.CoautorInternoArticulos }); %>
                
                  <% Html.RenderPartial("_AutorEntry", Model.Form); %>
                </span>

                <% Html.RenderPartial("_ShowEstadoProducto", 
                    new ShowFieldsForm { EstadosProductos = Model.Form.EstadosProductos, FechaAceptacion = Model.Form.FechaAceptacion, 
                        FechaPublicacion = Model.Form.FechaPublicacion, IsShowForm = false, ModelId = Model.Form.Id}); %>
                
                <% Html.RenderPartial("_RevistaPublicacion", Model.Form); %>
                <div class="EstatusPublicado">
                    <% Html.RenderPartial("_ReferenciaBibliografica", Model.Form); %>
                </div>

                <label>Pa&iacute;s</label>
                     <%=Html.DropDownList("Pais", Model.Form.Paises.CreateSelectList<PaisForm>("Id", "Nombre"),
                         "Seleccione ...", new { @class = "requerido"})%>
                <span class="cvu"></span>
                <%=Html.ValidationMessage("Pais") %>

                <% Html.RenderPartial("_DatosFinal", Model.Form); %>
				<% Html.RenderPartial("_EditArchivo", Model.Form); %>
				<% Html.RenderPartial("_ProgressBar"); %>
            
	            <p class="submit">
	                <%=Html.SubmitButton("Guardar", "Guardar cambios") %> &oacute; <%=Html.ActionLink<ArticuloDifusionController>(x => x.Index(), "Regresar", new { id = "regresar" })%>
	            </p>
	        <% } %>
	    </div><!--end forma-->
    
	</div><!--end textos-->

<script type="text/javascript">
    $(document).ready(function () {
        setupDocument();

        articuloSetup();
        setupOrden();

        var auth = "<% = Request.Cookies[FormsAuthentication.FormsCookieName]==null ? string.Empty : Request.Cookies[FormsAuthentication.FormsCookieName].Value %>";
        var uploader = '<%=ResolveUrl("~/Scripts/uploadify.swf") %>';
        var cancelImg = '<%=ResolveUrl("~/Content/Images/eliminar-icon.png") %>';
        var uploadImg = '<%=ResolveUrl("~/Content/Images/adjuntar.png") %>';
        var action = '<%=Url.Action("AddFile") %>';

        UploadMulti.setup('#uploadify', 'fileQueue', uploader, cancelImg, uploadImg, action, auth);
    });
</script>

</asp:Content>
