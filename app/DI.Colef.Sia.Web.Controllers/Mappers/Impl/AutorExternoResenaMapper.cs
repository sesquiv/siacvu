using System;
using DecisionesInteligentes.Colef.Sia.ApplicationServices;
using DecisionesInteligentes.Colef.Sia.Core;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Models;
using SharpArch.Core.PersistenceSupport;

namespace DecisionesInteligentes.Colef.Sia.Web.Controllers.Mappers
{
    public class AutorExternoResenaMapper : AutoFormMapper<AutorExternoResena, AutorExternoProductoForm>, IAutorExternoResenaMapper
    {
        readonly ICatalogoService catalogoService;
		
		public AutorExternoResenaMapper(IRepository<AutorExternoResena> repository,	ICatalogoService catalogoService) 
			: base(repository)
        {
			this.catalogoService = catalogoService;
        }

        protected override int GetIdFromMessage(AutorExternoProductoForm message)
        {
            return message.Id;
        }

        protected override void MapToModel(AutorExternoProductoForm message, AutorExternoResena model)
        {
            model.InvestigadorExterno = catalogoService.GetInvestigadorExternoById(message.InvestigadorExternoId);
            model.Institucion = catalogoService.GetInstitucionById(message.InstitucionId);
            model.AutorSeOrdenaAlfabeticamente = message.AutorSeOrdenaAlfabeticamente;
            model.Posicion = message.Posicion;

            if (model.IsTransient())
            {
                model.Activo = true;
                model.CreadoEl = DateTime.Now;
            }

            model.ModificadoEl = DateTime.Now;
        }
    }
}