using System;
using DecisionesInteligentes.Colef.Sia.ApplicationServices;
using DecisionesInteligentes.Colef.Sia.Core;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Models;
using SharpArch.Core.PersistenceSupport;

namespace DecisionesInteligentes.Colef.Sia.Web.Controllers.Mappers
{
    public class ParticipanteExternoProyectoMapper : AutoFormMapper<ParticipanteExternoProyecto, ParticipanteExternoProductoForm>, IParticipanteExternoProyectoMapper
    {
        readonly ICatalogoService catalogoService;

        public ParticipanteExternoProyectoMapper(IRepository<ParticipanteExternoProyecto> repository, ICatalogoService catalogoService)
            : base(repository)
        {
            this.catalogoService = catalogoService;
        }

        protected override int GetIdFromMessage(ParticipanteExternoProductoForm message)
        {
            return message.Id;
        }

        protected override void MapToModel(ParticipanteExternoProductoForm message, ParticipanteExternoProyecto model)
        {
            model.InvestigadorExterno = catalogoService.GetInvestigadorExternoById(message.InvestigadorExternoId);
            model.Institucion = catalogoService.GetInstitucionById(message.InstitucionId);
            model.ParticipanteSeOrdenaAlfabeticamente = message.ParticipanteSeOrdenaAlfabeticamente;
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