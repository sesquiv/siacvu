using System;
using System.Web.Mvc;
using DecisionesInteligentes.Colef.Sia.ApplicationServices;
using DecisionesInteligentes.Colef.Sia.Core;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Mappers;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Models;
using SharpArch.Web.NHibernate;

namespace DecisionesInteligentes.Colef.Sia.Web.Controllers.Catalogos
{
    [HandleError]
    public class TipoPresentacionController : BaseController<TipoPresentacion, TipoPresentacionForm>
    {
        readonly ICatalogoService catalogoService;
        readonly ITipoPresentacionMapper tipoPresentacionMapper;

        public TipoPresentacionController(IUsuarioService usuarioService, ICatalogoService catalogoService,
                                          ITipoPresentacionMapper tipoPresentacionMapper, ISearchService searchService)
            : base(usuarioService, searchService, catalogoService)
        {
            this.catalogoService = catalogoService;
            this.tipoPresentacionMapper = tipoPresentacionMapper;
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Index()
        {
            var data = CreateViewDataWithTitle(Title.Index);

            var tipoPresentacions = catalogoService.GetAllTipoPresentaciones();
            data.List = tipoPresentacionMapper.Map(tipoPresentacions);

            return View(data);
        }

        [Authorize(Roles = "DGAA")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult New()
        {
            var data = CreateViewDataWithTitle(Title.New);
            data.Form = new TipoPresentacionForm();

            return View(data);
        }

        [Authorize(Roles = "DGAA")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Edit(int id)
        {
            var data = CreateViewDataWithTitle(Title.Edit);

            var tipoPresentacion = catalogoService.GetTipoPresentacionById(id);
            data.Form = tipoPresentacionMapper.Map(tipoPresentacion);

            ViewData.Model = data;
            return View();
        }

        [Authorize(Roles = "DGAA")]
        [CustomTransaction]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(TipoPresentacionForm form)
        {
            var tipoPresentacion = tipoPresentacionMapper.Map(form);

            tipoPresentacion.CreadoPor = CurrentUser();
            tipoPresentacion.ModificadoPor = CurrentUser();

            if (!IsValidateModel(tipoPresentacion, form, Title.New))
                return ViewNew();

            catalogoService.SaveTipoPresentacion(tipoPresentacion);

            return RedirectToIndex(String.Format("Tipo de Presentacion {0} ha sido creada", tipoPresentacion.Nombre));
        }

        [Authorize(Roles = "DGAA")]
        [CustomTransaction]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update(TipoPresentacionForm form)
        {
            var tipoPresentacion = tipoPresentacionMapper.Map(form);

            tipoPresentacion.ModificadoPor = CurrentUser();

            if (!IsValidateModel(tipoPresentacion, form, Title.Edit))
                return ViewEdit();

            catalogoService.SaveTipoPresentacion(tipoPresentacion);

            return RedirectToIndex(String.Format("Tipo de Presentacion {0} ha sido modificada", tipoPresentacion.Nombre));
        }

        [Authorize(Roles = "DGAA")]
        [CustomTransaction]
        [AcceptVerbs(HttpVerbs.Put)]
        public ActionResult Activate(int id)
        {
            var tipoPresentacion = catalogoService.GetTipoPresentacionById(id);
            tipoPresentacion.Activo = true;
            tipoPresentacion.ModificadoPor = CurrentUser();
            catalogoService.SaveTipoPresentacion(tipoPresentacion);

            var form = tipoPresentacionMapper.Map(tipoPresentacion);

            return Rjs(form);
        }

        [Authorize(Roles = "DGAA")]
        [CustomTransaction]
        [AcceptVerbs(HttpVerbs.Put)]
        public ActionResult Deactivate(int id)
        {
            var tipoPresentacion = catalogoService.GetTipoPresentacionById(id);
            tipoPresentacion.Activo = false;
            tipoPresentacion.ModificadoPor = CurrentUser();
            catalogoService.SaveTipoPresentacion(tipoPresentacion);

            var form = tipoPresentacionMapper.Map(tipoPresentacion);

            return Rjs("Activate", form);
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Get)]
        public override ActionResult Search(string q)
        {
            var data = searchService.Search<TipoPresentacion>(x => x.Nombre, q);
            return Content(data);
        }
    }
}