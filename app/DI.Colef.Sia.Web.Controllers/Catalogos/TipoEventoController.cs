using System;
using System.Web.Mvc;
using DecisionesInteligentes.Colef.Sia.ApplicationServices;
using DecisionesInteligentes.Colef.Sia.Core;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Mappers;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Models;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData;

namespace DecisionesInteligentes.Colef.Sia.Web.Controllers.Catalogos
{
    [HandleError]
    public class TipoEventoController : BaseController<TipoEvento, TipoEventoForm>
    {
        readonly ITipoEventoMapper tipoEventoMapper;

        public TipoEventoController(IUsuarioService usuarioService, ICatalogoService catalogoService, ITipoEventoMapper tipoEventoMapper,
                                    ISearchService searchService)
            : base(usuarioService, searchService, catalogoService)
        {
            this.catalogoService = catalogoService;
            this.tipoEventoMapper = tipoEventoMapper;
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Index() 
        {
            var data = new GenericViewData<TipoEventoForm>();

            var tipoEventos = catalogoService.GetAllTipoEventos();
            data.List = tipoEventoMapper.Map(tipoEventos);

            return View(data);
        }
        
        [Authorize(Roles = "DGAA")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult New()
        {
            var data = new GenericViewData<TipoEventoForm> {Form = new TipoEventoForm()};

            return View(data);
        }
        
        [Authorize(Roles = "DGAA")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Edit(int id)
        {
            var data = new GenericViewData<TipoEventoForm>();

            var tipoEvento = catalogoService.GetTipoEventoById(id);
            data.Form = tipoEventoMapper.Map(tipoEvento);

            ViewData.Model = data;
            return View();
        }

        [Authorize(Roles = "DGAA")]
        [CustomTransaction]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(TipoEventoForm form)
        {
            var tipoEvento = tipoEventoMapper.Map(form);
            
            tipoEvento.CreadoPor = CurrentUser();
            tipoEvento.ModificadoPor = CurrentUser();

            if(!IsValidateModel(tipoEvento, form, Title.New))
                return ViewNew();

            catalogoService.SaveTipoEvento(tipoEvento);

            return RedirectToIndex(String.Format("Tipo de Evento {0} ha sido registrado", tipoEvento.Nombre));
        }
        
        [Authorize(Roles = "DGAA")]
        [CustomTransaction]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update(TipoEventoForm form)
        {
        
            var tipoEvento = tipoEventoMapper.Map(form);
            
            tipoEvento.ModificadoPor = CurrentUser();

            if (!IsValidateModel(tipoEvento, form, Title.Edit))
                return ViewEdit();

            catalogoService.SaveTipoEvento(tipoEvento);

            return RedirectToIndex(String.Format("Tipo de Evento {0} ha sido modificado", tipoEvento.Nombre));
        }
        
        [Authorize(Roles = "DGAA")]
        [CustomTransaction]
        [AcceptVerbs(HttpVerbs.Put)]
        public ActionResult Activate(int id)
        {
            var tipoEvento = catalogoService.GetTipoEventoById(id);
            tipoEvento.Activo = true;
            tipoEvento.ModificadoPor = CurrentUser();
            catalogoService.SaveTipoEvento(tipoEvento);

            var form = tipoEventoMapper.Map(tipoEvento);
            
            return Rjs(form);
        }
        
        [Authorize(Roles = "DGAA")]
        [CustomTransaction]
        [AcceptVerbs(HttpVerbs.Put)]
        public ActionResult Deactivate(int id)
        {
            var tipoEvento = catalogoService.GetTipoEventoById(id);
            tipoEvento.Activo = false;
            tipoEvento.ModificadoPor = CurrentUser();
            catalogoService.SaveTipoEvento(tipoEvento);

            var form = tipoEventoMapper.Map(tipoEvento);
            
            return Rjs("Activate", form);
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Get)]
        public override ActionResult Search(string q)
        {
            var data = searchService.Search<TipoEvento>(x => x.Nombre, q);
            return Content(data);
        }
    }
}