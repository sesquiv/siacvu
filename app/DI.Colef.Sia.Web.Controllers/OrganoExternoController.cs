using System;
using System.Web.Mvc;
using DecisionesInteligentes.Colef.Sia.ApplicationServices;
using DecisionesInteligentes.Colef.Sia.Core;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Mappers;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Models;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData;
using SharpArch.Web.NHibernate;

namespace DecisionesInteligentes.Colef.Sia.Web.Controllers
{
    [HandleError]
    public class OrganoExternoController : BaseController<OrganoExterno, OrganoExternoForm>
    {
        readonly IAmbitoMapper ambitoMapper;
        readonly ICatalogoService catalogoService;
        readonly INivelMapper nivelMapper;
        readonly IOrganoExternoMapper organoExternoMapper;
        readonly IOrganoExternoService organoExternoService;
        readonly ISectorMapper sectorMapper;
        readonly ITipoOrganoMapper tipoOrganoMapper;
        readonly ITipoParticipacionMapper tipoParticipacionMapper;


        public OrganoExternoController(IOrganoExternoService organoExternoService,
                                       IOrganoExternoMapper organoExternoMapper,
                                       ICatalogoService catalogoService, IUsuarioService usuarioService,
                                       ITipoOrganoMapper tipoOrganoMapper,
                                       ITipoParticipacionMapper tipoParticipacionMapper, ISectorMapper sectorMapper,
                                       INivelMapper nivelMapper,
                                       IAmbitoMapper ambitoMapper, ISearchService searchService)
            : base(usuarioService, searchService)
        {
            this.catalogoService = catalogoService;
            this.organoExternoService = organoExternoService;
            this.organoExternoMapper = organoExternoMapper;
            this.tipoOrganoMapper = tipoOrganoMapper;
            this.tipoParticipacionMapper = tipoParticipacionMapper;
            this.sectorMapper = sectorMapper;
            this.nivelMapper = nivelMapper;
            this.ambitoMapper = ambitoMapper;
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Index()
        {
            var data = CreateViewDataWithTitle(Title.Index);

            var organoExternos = organoExternoService.GetAllOrganoExternos();
            data.List = organoExternoMapper.Map(organoExternos);

            return View(data);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult New()
        {
            var data = CreateViewDataWithTitle(Title.New);
            data.Form = SetupNewForm();

            return View(data);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Edit(int id)
        {
            var data = CreateViewDataWithTitle(Title.Edit);

            var organoExterno = organoExternoService.GetOrganoExternoById(id);

            if (organoExterno == null)
                return RedirectToIndex("no ha sido encontrado", true);
            if (organoExterno.Investigador.Id != CurrentInvestigador().Id)
                return RedirectToIndex("no lo puede modificar", true);

            var organoExternoForm = organoExternoMapper.Map(organoExterno);

            data.Form = SetupNewForm(organoExternoForm);
            FormSetCombos(data.Form);

            ViewData.Model = data;
            return View();
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Show(int id)
        {
            var data = CreateViewDataWithTitle(Title.Show);

            var organoExterno = organoExternoService.GetOrganoExternoById(id);
            data.Form = organoExternoMapper.Map(organoExterno);

            ViewData.Model = data;
            return View();
        }

        [Transaction]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(OrganoExternoForm form)
        {
            var organoExterno = organoExternoMapper.Map(form, CurrentUser(), CurrentInvestigador());

            if (!IsValidateModel(organoExterno, form, Title.New, "OrganoExterno"))
            {
                ((GenericViewData<OrganoExternoForm>) ViewData.Model).Form = SetupNewForm();
                return ViewNew();
            }

            organoExternoService.SaveOrganoExterno(organoExterno);

            return RedirectToIndex(String.Format("{0} ha sido creado", organoExterno.Nombre));
        }

        [Transaction]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update(OrganoExternoForm form)
        {
            var organoExterno = organoExternoMapper.Map(form, CurrentUser(), CurrentInvestigador());

            if (!IsValidateModel(organoExterno, form, Title.Edit))
            {
                var organoExternoForm = organoExternoMapper.Map(organoExterno);
                ((GenericViewData<OrganoExternoForm>) ViewData.Model).Form = SetupNewForm(organoExternoForm);
                FormSetCombos(organoExternoForm);
                return ViewEdit();
            }

            organoExternoService.SaveOrganoExterno(organoExterno);

            return RedirectToIndex(String.Format("{0} ha sido modificado", organoExterno.Nombre));
        }

        [Transaction]
        [AcceptVerbs(HttpVerbs.Put)]
        public ActionResult Activate(int id)
        {
            var organoExterno = organoExternoService.GetOrganoExternoById(id);

            if (organoExterno.Investigador.Id != CurrentInvestigador().Id)
                return RedirectToIndex("no lo puede modificar", true);

            organoExterno.Activo = true;
            organoExterno.ModificadoPor = CurrentUser();
            organoExternoService.SaveOrganoExterno(organoExterno);

            var form = organoExternoMapper.Map(organoExterno);

            return Rjs(form);
        }

        [Transaction]
        [AcceptVerbs(HttpVerbs.Put)]
        public ActionResult Deactivate(int id)
        {
            var organoExterno = organoExternoService.GetOrganoExternoById(id);

            if (organoExterno.Investigador.Id != CurrentInvestigador().Id)
                return RedirectToIndex("no lo puede modificar", true);

            organoExterno.Activo = false;
            organoExterno.ModificadoPor = CurrentUser();
            organoExternoService.SaveOrganoExterno(organoExterno);

            var form = organoExternoMapper.Map(organoExterno);

            return Rjs("Activate", form);
        }

        OrganoExternoForm SetupNewForm()
        {
            return SetupNewForm(null);
        }

        OrganoExternoForm SetupNewForm(OrganoExternoForm form)
        {
            form = form ?? new OrganoExternoForm();

            form.TiposOrganos = tipoOrganoMapper.Map(catalogoService.GetActiveTipoOrganos());
            form.TiposParticipaciones = tipoParticipacionMapper.Map(catalogoService.GetActiveTipoParticipaciones());
            form.Sectores = sectorMapper.Map(catalogoService.GetActiveSectores());
            form.Niveles = nivelMapper.Map(catalogoService.GetActiveNiveles());
            form.Ambitos = ambitoMapper.Map(catalogoService.GetActiveAmbitos());

            return form;
        }

        void FormSetCombos(OrganoExternoForm form)
        {
            ViewData["TipoOrgano"] = form.TipoOrganoId;
            ViewData["TipoParticipacion"] = form.TipoParticipacionId;
            ViewData["Sector"] = form.SectorId;
            ViewData["Nivel"] = form.NivelId;
            ViewData["Ambito"] = form.AmbitoId;
        }
    }
}