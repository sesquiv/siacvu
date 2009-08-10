using System;
using DecisionesInteligentes.Colef.Sia.ApplicationServices;
using DecisionesInteligentes.Colef.Sia.Core;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Models;
using DecisionesInteligentes.Colef.Sia.Web.Extensions;
using SharpArch.Core.PersistenceSupport;

namespace DecisionesInteligentes.Colef.Sia.Web.Controllers.Mappers
{
    public class ParticipacionMapper : AutoFormMapper<Participacion, ParticipacionForm>, IParticipacionMapper
    {
		readonly ICatalogoService catalogoService;
        readonly IInvestigadorService investigadorService;

		public ParticipacionMapper(IRepository<Participacion> repository,
		    ICatalogoService catalogoService,
            IInvestigadorService investigadorService
		) : base(repository)
        {
			this.catalogoService = catalogoService;
            this.investigadorService = investigadorService;
        }
		
        protected override int GetIdFromMessage(ParticipacionForm message)
        {
            return message.Id;
        }

        protected override void MapToModel(ParticipacionForm message, Participacion model)
        {
            model.Titulo = message.Titulo;
            model.Institucion = message.Institucion;
            model.Lugar = message.Lugar;
            model.Ciudad = message.Ciudad;

            model.FechaPresentacion = message.FechaPresentacion.FromShortDateToDateTime();

			model.OtraParticipacion = catalogoService.GetOtraParticipacionById(message.OtraParticipacion);
		    model.TipoPresentacion = catalogoService.GetTipoPresentacionById(message.TipoPresentacion);
		    model.PeriodoReferencia = catalogoService.GetPeriodoReferenciaById(message.PeriodoReferencia);
		    model.Proyecto = catalogoService.GetProyectoById(message.Proyecto);
		    model.Pais = catalogoService.GetPaisById(message.Pais);
		    model.EstadoPais = catalogoService.GetEstadoPaisById(message.EstadoPais);
            model.Autor = investigadorService.GetInvestigadorById(message.Autor);
        }

        public Participacion Map(ParticipacionForm message, Usuario usuario, Investigador investigador)
        {
            var model = Map(message);

            if (model.IsTransient())
            {
                model.Investigador = investigador;
                model.CreadorPor = usuario;
            }

            model.ModificadoPor = usuario;

            return model;
        }
    }
}
