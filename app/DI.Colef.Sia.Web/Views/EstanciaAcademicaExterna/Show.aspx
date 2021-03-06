﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true"
    Inherits="System.Web.Mvc.ViewPage<GenericViewData<EstanciaAcademicaExternaForm>>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models" %>

<asp:Content ID="titleContent" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    <h2>
        <%=Html.Encode(Model.Title) %>
    </h2>
</asp:Content>

<asp:Content ID="introductionContent" ContentPlaceHolderID="IntroduccionPlaceHolder" runat="server">
    <div id="introduccion">
        <p>
            Aqu&iacute; se muestra la informaci&oacute;n detallada de la estancia acad&eacute;mica externa como est&aacute; en el sistema.
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
                <h4>Investigador externo</h4>
                <p>
                    <label>Nombre del investigador externo</label>
                    <span class="valor"><%= Html.Encode(Model.Form.InvestigadorExterno)%>&nbsp;</span>
                </p>
	            <p>
                    <label>Grado acad&eacute;mico</label>
                    <span class="valor"><%= Html.Encode(Model.Form.GradoAcademicoNombre)%>&nbsp;</span>
                </p>
                <p>
                    <label>Tipo de estancia</label>
                    <span class="valor"><%= Html.Encode(Model.Form.TipoEstanciaNombre)%>&nbsp;</span>
                </p>
                
                <h4>Datos de la estancia acad&eacute;mica externa</h4>                
                <% Html.RenderPartial("_ShowInstitucionLong", Model.Form); %>
                
                <p>
                    <label>L&iacute;neas de investigaci&oacute;n</label>
                    <span class="valor"><%= Html.Encode(Model.Form.LineasInvestigacion)%>&nbsp;</span>
                </p>
                <p>
                    <label>Departamento de adscripci&oacute;n</label>
                    <span class="valor"><%= Html.Encode(Model.Form.DepartamentoNombre)%>&nbsp;</span>
                </p>
                <p>
                    <label>Sede</label>
                    <span class="valor"><%= Html.Encode(Model.Form.SedeNombre)%>&nbsp;</span>
                </p>
                <p>
                    <label>Adscripci&oacute;n regional:</label>
                    <span class="valor"><%= Html.Encode(Model.Form.SedeDireccionRegionalNombre)%>&nbsp;</span>
                </p>
                <p>
                    <label>Fecha de inicio</label>
                    <span class="valor"><%= Html.Encode(Model.Form.FechaInicial)%>&nbsp;</span>
                    <span>Formato (dd/mm/aaaa)</span>
                </p>
                <p>
                    <label>Fecha de conclusi&oacute;n</label>
                    <span class="valor"><%= Html.Encode(Model.Form.FechaFinal)%>&nbsp;</span>
                    <span>Formato (dd/mm/aaaa)</span>
                </p>
                <p>
                    <label>Actividades acad&eacute;micas previstas</label>
                    <span class="valor"><%= Html.Encode(Model.Form.Actividades)%>&nbsp;</span>
                </p>
                <p>
                    <label>Principales logros</label>
                    <span class="valor"><%= Html.Encode(Model.Form.Logros)%>&nbsp;</span>
                </p>

                <% Html.RenderPartial("_ShowArchivo", Model.Form); %>
                                
                <p class="submit">
                    <%=Html.ActionLink<EstanciaAcademicaExternaController>(x => x.Index(), "Regresar") %>
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