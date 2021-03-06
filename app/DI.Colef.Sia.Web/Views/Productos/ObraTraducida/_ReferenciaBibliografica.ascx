﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl<ObraTraducidaForm>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Extensions" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models" %>
<div class="Articulo_fields"> 
    <% Html.RenderPartial("_RevistaPublicacion", Model); %>
</div>
<p class="Capitulo_fields">
    <label>T&iacute;tulo del libro</label>
    <%=Html.TextBox("NombreLibro", Model.NombreLibro, new { @class = "input420-requerido", maxlength = 100 })%>
    <%=Html.ValidationMessage("NombreLibro")%>
</p>
<div class="Capitulo_fields">
    <h4>Autor(es) del libro</h4>
    <% Html.RenderPartial("_AddButtons", new ShowFieldsForm { ModelId = Model.Id, CheckboxName = "AutorSeOrdenaAlfabeticamente", CheckboxValue = Model.CoautorSeOrdenaAlfabeticamente, Rel = "NewAutorInternoLink, NewAutorExternoLink", SubFormName = "autor", UrlActionExterno = "NewAutorExterno", UrlActionInterno = "NewAutorInterno", Link1Id = "NewAutorInternoLink", Link2Id = "NewAutorExternoLink" }); %>
    <% Html.RenderPartial("_EditAutorInterno", new AutorForm { AutoresInternos = Model.AutorInternoObraTraducidas, ModelId = Model.Id, AutorSeOrdenaAlfabeticamente = Model.AutorSeOrdenaAlfabeticamente }); %>
    <% Html.RenderPartial("_EditAutorExterno", new AutorForm { AutoresExternos = Model.AutorExternoObraTraducidas, ModelId = Model.Id, AutorSeOrdenaAlfabeticamente = Model.AutorSeOrdenaAlfabeticamente }); %>
    <% Html.RenderPartial("_AutorEmptyListMessage", new AutorForm { AutoresExternos = Model.AutorExternoObraTraducidas, AutoresInternos = Model.AutorInternoObraTraducidas }); %>
<%--    <p>
        <label>Investigador</label>
        <span class="valor"><%=Html.Encode(Model.InvestigadorNombre) %></span>
    </p>
    <p id="AutorSeOrdenaAlfabeticamente_field">
        <label>Posici&oacute;n del autor</label>
        <%=Html.TextBox("PosicionAutor", Model.PosicionAutor, new { @class = "input100-requerido", maxlength = 2 })%>
        <span class="cvu"></span>
        <%=Html.ValidationMessage("PosicionAutor")%>
    </p>
    <p>
        <label>Total de investigadores</label>
        <span id="totalautores" class="valor"><%=Html.Encode(Model.TotalAutores) %></span>
        <span class="cvu"></span>
    </p>--%>
</div>
<p class="Capitulo_fields">
    <label>Tipo de libro</label>
    <%=Html.DropDownList("TipoLibro", Model.TiposLibro.CreateSelectList<CustomSelectForm>("Id", "Nombre"),
        "Seleccione ...", new { @class = "requerido" })%>
    <%=Html.ValidationMessage("TipoLibro")%>
</p>
<div class="CapituloLibro_fields">
    <% Html.RenderPartial("_EditEditorial", Model); %>
</div>
<p class="Capitulo_fields">
    <label>Resumen</label>
    <%=Html.TextArea("Resumen", Model.Resumen, 4, 35, new { @class = "input420-requerido", maxlength = 300 })%>
    <%=Html.ValidationMessage("Resumen")%>
</p>
<p class="Libro_fields">
    <label>ISBN</label>
    <%=Html.TextBox("ISBN", Model.ISBN, new { @class = "input420-requerido", maxlength = 100 })%>
    <%=Html.ValidationMessage("ISBN")%>
</p>
<p class="Libro_fields">
    <label>Edici&oacute;n</label>
    <%=Html.DropDownList("Edicion", Model.Ediciones.CreateSelectList<CustomSelectForm>("Id", "Nombre"),
        "Seleccione ...", new { @class = "requerido" })%>
    <%=Html.ValidationMessage("Edicion")%>
</p>
<p class="Libro_fields">
    <label>Reimpresi&oacute;n</label>
    <%=Html.DropDownList("Reimpresion", Model.Reimpresiones.CreateSelectList<CustomSelectForm>("Id", "Nombre"),
        "Seleccione ...", new { @class = "requerido" })%>
    <%=Html.ValidationMessage("Reimpresion")%>
</p>
<p class="ArticuloCapituloLibro_fields">
    <label>Volumen</label>
    <%=Html.TextBox("Volumen", Model.Volumen, new { @class = "input100-requerido", maxlength = 4 })%>
    <%=Html.ValidationMessage("Volumen")%>
</p>
<p class="Articulo_fields">
    <label>N&uacute;mero</label>
    <%=Html.TextBox("Numero", Model.Numero, new { @class = "input100-requerido", maxlength = 4 })%>
    <%=Html.ValidationMessage("Numero")%>
</p>
<p class="ArticuloCapitulo_fields">
    <label>De la p&aacute;gina</label>
    <%=Html.TextBox("PaginaInicial", Model.PaginaInicial, new { @class = "input100-requerido", maxlength = 4 })%>
    <%=Html.ValidationMessage("PaginaInicial")%>
</p>
<p class="ArticuloCapitulo_fields">
    <label>A la p&aacute;gina</label>
    <%=Html.TextBox("PaginaFinal", Model.PaginaFinal, new { @class = "input100-requerido", maxlength = 4 })%>
    <%=Html.ValidationMessage("PaginaFinal")%>
</p>

<p class="Articulo_fields">
    <label>Pa&iacute;s</label>
    <%=Html.DropDownList("Pais", Model.Paises.CreateSelectList<PaisForm>("Id", "Nombre"),
        "Seleccione ...", new { @class = "requerido" })%>
    <%=Html.ValidationMessage("Pais")%>
</p>

<p class="Libro_fields">
    <label>N&uacute;mero de p&aacute;ginas</label>
    <%=Html.TextBox("NoPaginas", Model.NoPaginas, new { @class = "input100-requerido", maxlength = 4 })%>
    <%=Html.ValidationMessage("NoPaginas")%>
</p>
<p class="Capitulo_fields">
    <label>N&uacute;mero de citas</label>
    <%=Html.TextBox("NoCitas", Model.NoCitas, new { @class = "input100-requerido", maxlength = 4 })%>
    <%=Html.ValidationMessage("NoCitas")%>
</p>
<p class="Libro_fields">
    <label>Tiraje</label>
    <%=Html.TextBox("Tiraje", Model.Tiraje, new { @class = "input100-requerido", maxlength = 4 })%>
    <%=Html.ValidationMessage("Tiraje")%>
</p>
