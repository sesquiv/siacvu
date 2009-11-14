﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true"
    Inherits="System.Web.Mvc.ViewPage<GenericViewData<LibroForm>>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Helpers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Productos"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Extensions" %>
<%@ Import Namespace="DI.Colef.Sia.Web.Controllers" %>

<asp:Content ID="titleContent" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    <h2>
        <%=Html.Encode(Model.Title) %>
    </h2>
</asp:Content>

<asp:Content ID="introductionContent" ContentPlaceHolderID="IntroduccionPlaceHolder" runat="server">
    <div id="introduccion">
        <p>
            Aqu&iacute; se muestra la informaci&oacute;n detallada del libro como est&aacute; en el sistema.
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
                <h4>Datos del investigador</h4>
	            <p>
                    <label>Departamento</label>
                    <span class="valor"><%= Html.Encode(Model.Form.DepartamentoNombre)%>&nbsp;</span>
                </p>
                <p>
                    <label>Sede</label>
                    <span class="valor"><%= Html.Encode(Model.Form.SedeNombre)%>&nbsp;</span>
                </p>
    <!--DATOS PUBLICACION-->
                <h4>Datos de la publicaci&oacute;n</h4>
                <p>
                    <label>Nombre del libro</label>
                    <span class="valor"><%= Html.Encode(Model.Form.Nombre) %>&nbsp;</span>
                </p>
                <p>
                    <label>Tipo de publicaci&oacute;n</label>
                    <span class="valor"><%= Html.Encode(Model.Form.TipoPublicacionNombre)%>&nbsp;</span>
                </p>
                <p>
                    <label>Tipo de producto</label>
                    <span class="valor"><%= HumanizeHelper.TipoProducto(Model.Form.TipoProducto)%>&nbsp;</span>
                </p>
                <p>
                    <label>Formato de publicaci&oacute;n</label>
                    <span class="valor"><%= Html.Encode(Model.Form.FormatoPublicacionNombre)%>&nbsp;</span>
                </p>
                
                <% if (Model.Form.FormatoPublicacionNombre.Contains("evento")){ %>
                    <p>
                        <label>Nombre del evento</label>
                        <span class="valor"><%= Html.Encode(Model.Form.EventoNombre)%>&nbsp;</span>
                    </p>
                    <p>
                        <label>Fecha del evento</label>
                        <span class="valor"><%= Html.Encode(Model.Form.EventoFechaInicial)%> - <%= Html.Encode(Model.Form.EventoFechaFinal)%> &nbsp;</span>
                    </p>
                <% } %>
                
                <% if (Model.Form.FormatoPublicacionNombre.Contains("revista")){ %>
                    <p>
                        <label>Nombre de la revista</label>
                        <span class="valor"><%= Html.Encode(Model.Form.NombreRevistaTitulo)%>&nbsp;</span>
                    </p>
                    <% Html.RenderPartial("_ShowRevista", Model.Form.ShowFields); %>
                    <p>
                        <label>N&uacute;mero</label>
                        <span class="valor"><%= Html.Encode(Model.Form.Numero)%>&nbsp;</span>
                    </p>
                <% } %>
                
                <% if (Model.Form.FormatoPublicacionNombre.Contains("otro idioma")){ %>
                    <p>
                        <label>Idioma</label>
                        <span class="valor"><%= Html.Encode(Model.Form.IdiomaNombre)%>&nbsp;</span>
                    </p>
                    <p>
                        <label>Nombre del traductor</label>
                        <span class="valor"><%= Html.Encode(Model.Form.NombreTraductor)%>&nbsp;</span>
                    </p>
                <% } %>
                
                <h4>Coautores</h4>
				<% Html.RenderPartial("_ShowCoautorInterno",
                                       new CoautorForm { CoautoresInternos = Model.Form.CoautorInternoLibros, ModelId = Model.Form.Id });%>
	            <% Html.RenderPartial("_ShowCoautorExterno",
				                       new CoautorForm { CoautoresExternos = Model.Form.CoautorExternoLibros, ModelId = Model.Form.Id});%>
	            <p>
	                <label>Total de autores</label>
	                <span id="totalcoautores" class="valor"><%=Html.Encode(Model.Form.TotalAutores)%></span>	          
	            </p>
                <p>
	                <label>Posici&oacute;n del autor</label>
                    <span class="valor"><%=Html.Encode(Model.Form.PosicionAutor)%>&nbsp;</span>
                </p>
                <p>
                    <label></label>
                    <span class="valor">Tiene proyecto de investigaci&oacute;n de referencia? <%= HumanizeHelper.Boolean(Model.Form.TieneProyecto)%>&nbsp;</span>
                </p>
                
                <% if (Model.Form.TieneProyecto) { %>
                    <p>
                        <label>Nombre del proyecto de investigaci&oacute;n</label>
                        <span class="valor"><%= Html.Encode(Model.Form.ProyectoNombre)%>&nbsp;</span>
                    </p>
                    
                    <% Html.RenderPartial("_ShowProyecto", Model.Form.ShowFields); %>
                <% } else { %>
                    <% Html.RenderPartial("_ShowAreaTematica", Model.Form.ShowFields); %>
                <% } %>
                
                <p>
	                <label>Palabra clave 1</label>
	                <span class="valor"><%= Html.Encode(Model.Form.PalabraClave1)%>&nbsp;</span>
                </p>
                <p>
	                <label>Palabra clave 2</label>
	                <span class="valor"><%= Html.Encode(Model.Form.PalabraClave2)%>&nbsp;</span>
                </p>
                <p>
	                <label>Palabra clave 3</label>
                    <span class="valor"><%= Html.Encode(Model.Form.PalabraClave3)%>&nbsp;</span>
                </p>
                <p>
                    <label>Estado actual</label>
                    <span class="valor"><%= HumanizeHelper.EstadoProducto(Model.Form.EstadoProducto)%>&nbsp;</span>
                </p>
                
                <% if (Model.Form.EstadoProducto == 1) { %>
                    <p>
                        <label>Fecha de aceptaci&oacute;n</label>
                        <span class="valor"><%= Html.Encode(Model.Form.FechaAceptacion)%>&nbsp;</span><span>Formato (dd/mm/yyyy)</span>
                    </p>
                <% } if (Model.Form.EstadoProducto == 2){ %>
                    <p>
                        <label>Fecha de publicaci&oacute;n</label>
                        <span class="valor"><%= Html.Encode(Model.Form.FechaPublicacion)%>&nbsp;</span><span>Formato (dd/mm/yyyy)</span>
                    </p>
                <% } %>
                
    <!--DATOS REFERENCIA BIBLIOGRAFICA-->
                <h4>Referencia bibliogr&aacute;fica</h4>
                <p>
                    <label>Edici&oacute;n</label>
                    <span class="valor"><%= HumanizeHelper.Edicion(Model.Form.Edicion)%>&nbsp;</span>
                </p>
                <p>
                    <label>Reimpresi&oacute;n</label>
                    <span class="valor"><%= HumanizeHelper.Reimpresion(Model.Form.Reimpresion)%>&nbsp;</span>
                </p>
                
                <% Html.RenderPartial("_ShowEditorial", Model.Form); %>
                
                <p>
                    <label>ISBN</label>
                    <span class="valor"><%= Html.Encode(Model.Form.ISBN)%>&nbsp;</span>
                </p>
                <p>
                    <label>A&ntilde;o de edici&oacute;n</label>
                    <span class="valor"><%= Html.Encode(Model.Form.FechaEdicion)%>&nbsp;</span><span>Formato (yyyy)</span>
                </p>
                <p>
                    <label>Volumen</label>
                    <span class="valor"><%= HumanizeHelper.Volumen(Model.Form.Volumen)%>&nbsp;</span>
                </p>
                <p>
                    <label>No. de p&aacute;ginas</label>
                    <span class="valor"><%= Html.Encode(Model.Form.NoPaginas)%>&nbsp;</span>
                </p>
                <p>
                    <label>Tiraje</label>
                    <span class="valor"><%= Html.Encode(Model.Form.Tiraje)%>&nbsp;</span>
                </p>           
                
                <p class="submit">
                    <%=Html.ActionLink<LibroController>(x => x.Index(), "Regresar") %>
                </p>
            </div><!--end elementodescripcion-->
        </div><!--end lista-->

    </div><!--end textos-->
    
<script type="text/javascript">
    $(document).ready(function() {
        setupDocument();
    });
</script>
</asp:Content>