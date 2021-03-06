<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" 
    Inherits="System.Web.Mvc.ViewPage<GenericViewData<OrganoInternoForm>>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Core"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Helpers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Productos"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models"%>
<%@ Import Namespace="DI.Colef.Sia.Web.Controllers" %>

<asp:Content ID="titleContent" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    <h2>
        <%=Html.ProductoEditTitle(TipoProductoEnum.OrganoInterno) %>
    </h2>
</asp:Content>

<asp:Content ID="introductionContent" ContentPlaceHolderID="IntroduccionPlaceHolder" runat="server">
    <div id="introduccion">
        <p>
            <%=Html.ProductoEditMessage(TipoProductoEnum.OrganoInterno) %>
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
	        <% using (Html.BeginForm("Update", "OrganoInterno", FormMethod.Post, new { @class = "remote" })){ %>
	            <%=Html.AntiForgeryToken() %>
				<%=Html.Hidden("Id", Model.Form.Id) %>
                <%=Html.Hidden("Contexto", "organoInterno", new { url = Url.Action("Glosario") })%>
				
				<h4>Datos del &oacute;rgano interno</h4>
                <% Html.RenderPartial("_DatosOrganoInterno", Model.Form); %>
                
                <% Html.RenderPartial("_EditArchivo", Model.Form); %>
                
                <% Html.RenderPartial("_ProgressBar"); %>
	            
	            <p class="submit">
	                <%=Html.SubmitButton("Guardar", "Guardar Cambios") %> &oacute; <%=Html.ActionLink<OrganoInternoController>(x => x.Index(), "Regresar", new { id = "regresar" })%>
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
        organoInternoSetup();

        var auth = "<% = Request.Cookies[FormsAuthentication.FormsCookieName]==null ? string.Empty : Request.Cookies[FormsAuthentication.FormsCookieName].Value %>";
        var uploader = '<%=ResolveUrl("~/Scripts/uploadify.swf") %>';
        var cancelImg = '<%=ResolveUrl("~/Content/Images/eliminar-icon.png") %>';
        var uploadImg = '<%=ResolveUrl("~/Content/Images/adjuntar.png") %>';
        var action = '<%=Url.Action("AddFile") %>';

        UploadMulti.setup('#uploadify', 'fileQueue', uploader, cancelImg, uploadImg, action, auth);
    });
</script>
</asp:Content>