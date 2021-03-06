﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl<GenericViewData<RolForm>>" %>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers"%>
<%@ Import Namespace="DecisionesInteligentes.Colef.Sia.Web.Controllers.Models"%>

<div id="form">
    <%=Html.AntiForgeryToken() %>
    <%=Html.Hidden("Id", Model.Form.Id) %>

    <table class="form">
        <tr>
            <td class="label required">
                <label for="Nombre">Nombre:<em>*</em></label>
            </td>
            <td class="field">
                <%=Html.TextBox("Nombre", Model.Form.Nombre, new { @class = "big", size = 10, maxlength = 40 })%>
                <span>(Debe de ser un nombre &uacute;nico)</span>
                <%=Html.ValidationMessage("Nombre") %>
            </td>
        </tr>
    </table>
    
	<div class="minilistaboton">
		<span class="btn btn_normal_brown">
			<%=Html.SubmitButton("Guardar", "Guardar cambios") %>
		</span>
		<span class="btn btn_normal_white">
			<%=Html.ActionLink<RolController>(x => x.Index(), "Regresar") %>
		</span>
	</div>    
</div>

