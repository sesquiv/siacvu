using System;
using System.Linq;
using System.Web.Mvc;
using DecisionesInteligentes.Colef.Sia.ApplicationServices;
using DecisionesInteligentes.Colef.Sia.Core;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Collections;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Helpers;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Mappers;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.Models;
using DecisionesInteligentes.Colef.Sia.Web.Controllers.ViewData;

namespace DecisionesInteligentes.Colef.Sia.Web.Controllers.Productos
{
    [HandleError]
    public class ResenaController : BaseController<Resena, ResenaForm>
    {
        readonly IAreaTematicaMapper areaTematicaMapper;
        readonly ICoautorExternoResenaMapper coautorExternoResenaMapper;
        readonly ICoautorInternoResenaMapper coautorInternoResenaMapper;
        readonly ICustomCollection customCollection;
        readonly ILineaTematicaMapper lineaTematicaMapper;
        readonly IPaisMapper paisMapper;
        readonly IResenaMapper resenaMapper;
        readonly IResenaService resenaService;
        readonly IAreaMapper areaMapper;
        readonly IRevistaPublicacionMapper revistaPublicacionMapper;
        readonly IAutorInternoResenaMapper autorInternoResenaMapper;
        readonly IAutorExternoResenaMapper autorExternoResenaMapper;
        readonly IEditorialResenaMapper editorialResenaMapper;
        readonly IInvestigadorExternoMapper investigadorExternoMapper;

        public ResenaController(IResenaService resenaService,
                                IResenaMapper resenaMapper,
                                IAutorInternoResenaMapper autorInternoResenaMapper,
                                IAreaMapper areaMapper,
                                IDisciplinaMapper disciplinaMapper,
                                ISubdisciplinaMapper subdisciplinaMapper,
                                IAutorExternoResenaMapper autorExternoResenaMapper,
                                IEditorialResenaMapper editorialResenaMapper,
                                ICatalogoService catalogoService,
                                IAreaTematicaMapper areaTematicaMapper,
                                IUsuarioService usuarioService,
                                ICustomCollection customCollection,
                                IPaisMapper paisMapper,
                                ICoautorExternoResenaMapper coautorExternoResenaMapper,
                                ICoautorInternoResenaMapper coautorInternoResenaMapper,
                                ISearchService searchService,
                                IRevistaPublicacionMapper revistaPublicacionMapper,
                                ILineaTematicaMapper lineaTematicaMapper,
                                IInvestigadorExternoMapper investigadorExternoMapper
            ) : base(usuarioService, searchService, catalogoService, disciplinaMapper, subdisciplinaMapper)
        {
            this.areaTematicaMapper = areaTematicaMapper;
            this.areaMapper = areaMapper;
            this.revistaPublicacionMapper = revistaPublicacionMapper;
            this.resenaService = resenaService;
            this.resenaMapper = resenaMapper;
            this.customCollection = customCollection;
            this.paisMapper = paisMapper;
            this.autorInternoResenaMapper = autorInternoResenaMapper;
            this.autorExternoResenaMapper = autorExternoResenaMapper;
            this.editorialResenaMapper = editorialResenaMapper;
            this.coautorExternoResenaMapper = coautorExternoResenaMapper;
            this.coautorInternoResenaMapper = coautorInternoResenaMapper;
            this.lineaTematicaMapper = lineaTematicaMapper;
            this.investigadorExternoMapper = investigadorExternoMapper;
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Index()
        {
            var data = CreateViewDataWithTitle(Title.Index);
            var resenas = new Resena[] {};

            if (User.IsInRole("Investigadores"))
                resenas = resenaService.GetAllResenas(CurrentUser());
            if (User.IsInRole("DGAA"))
                resenas = resenaService.GetAllResenas();

            data.List = resenaMapper.Map(resenas);

            return View(data);
        }

        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult New()
        {
            if (CurrentInvestigador() == null)
                return NoInvestigadorProfile("Por tal motivo no puede crear nuevos productos.");

            var data = CreateViewDataWithTitle(Title.New);
            data.Form = SetupNewForm();
            ViewData["Pais"] = (from p in data.Form.Paises where p.Nombre == "M�xico" select p.Id).FirstOrDefault();
            data.Form.PosicionAutor = 1;

            return View(data);
        }

        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Edit(int id)
        {
            CoautorInternoResena coautorInternoResena;
            int posicionAutor;
            var data = CreateViewDataWithTitle(Title.Edit);

            var resena = resenaService.GetResenaById(id);

            if (resena == null)
                return RedirectToIndex("no ha sido encontrado", true);

            var coautorExists =
                resena.CoautorInternoResenas.Where(
                    x => x.Investigador.Id == CurrentInvestigador().Id).Count();

            if (resena.Usuario.Id != CurrentUser().Id && coautorExists == 0)
                return RedirectToIndex("no lo puede modificar", true);

            var resenaForm = resenaMapper.Map(resena);

            data.Form = SetupNewForm(resenaForm);

            FormSetCombos(data.Form);

            if (coautorExists != 0)
            {
                coautorInternoResena =
                    resena.CoautorInternoResenas.Where(x => x.Investigador.Id == CurrentInvestigador().Id).
                        FirstOrDefault();

                posicionAutor = coautorInternoResena.Posicion;
            }
            else
                posicionAutor = data.Form.PosicionAutor;

            data.Form.PosicionAutor = posicionAutor;

            ViewData.Model = data;
            return View();
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Show(int id)
        {
            var data = CreateViewDataWithTitle(Title.Show);

            var resena = resenaService.GetResenaById(id);

            var resenaForm = resenaMapper.Map(resena);
            data.Form = SetupShowForm(resenaForm);

            ViewData.Model = data;
            return View();
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create([Bind(Prefix = "CoautorInterno")] CoautorInternoProductoForm[] coautorInterno,
                                   [Bind(Prefix = "CoautorExterno")] CoautorExternoProductoForm[] coautorExterno,
                                   [Bind(Prefix = "AutorExterno")] AutorExternoProductoForm[] autorExterno,
                                   [Bind(Prefix = "AutorInterno")] AutorInternoProductoForm[] autorInterno,
                                   [Bind(Prefix = "Editorial")] EditorialProductoForm[] editorial,
                                   ResenaForm form)
        {
            coautorExterno = coautorExterno ?? new CoautorExternoProductoForm[] {};
            coautorInterno = coautorInterno ?? new CoautorInternoProductoForm[] {};
            autorExterno = autorExterno ?? new AutorExternoProductoForm[] { };
            autorInterno = autorInterno ?? new AutorInternoProductoForm[] { };
            editorial = editorial ?? new EditorialProductoForm[] { };

            var resena = resenaMapper.Map(form, CurrentUser(), CurrentInvestigador(),
                                          coautorExterno, coautorInterno, autorExterno, autorInterno, editorial);

            if (!IsValidateModel(resena, form, Title.New, "Resena"))
            {
                var resenaForm = resenaMapper.Map(resena);

                ((GenericViewData<ResenaForm>) ViewData.Model).Form = SetupNewForm(resenaForm);
                FormSetCombos(resenaForm);
                return ViewNew();
            }

            resenaService.SaveResena(resena);

            return RedirectToIndex(String.Format("Rese�a {0} ha sido creada", resena.NombreProducto));
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update(ResenaForm form)
        {
            var resena = resenaMapper.Map(form, CurrentUser(), CurrentInvestigador());

            if (!IsValidateModel(resena, form, Title.Edit))
            {
                var resenaForm = resenaMapper.Map(resena);

                ((GenericViewData<ResenaForm>) ViewData.Model).Form = SetupNewForm(resenaForm);
                FormSetCombos(resenaForm);
                return ViewEdit();
            }

            resenaService.SaveResena(resena);

            return RedirectToIndex(String.Format("Rese�a {0} ha sido modificada", resena.NombreProducto));
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Get)]
        public override ActionResult Search(string q)
        {
            var data = searchService.Search<Resena>(x => x.NombreProducto, q);
            return Content(data);
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ChangeRevista(int select)
        {
            var revistaForm = revistaPublicacionMapper.Map(catalogoService.GetRevistaPublicacionById(select));

            var form = new ShowFieldsForm
            {
                RevistaPublicacionId = revistaForm.Id,

                RevistaPublicacionInstitucionNombre = revistaForm.InstitucionNombre,
                RevistaPublicacionPaisNombre = revistaForm.PaisNombre,
                RevistaPublicacionIndice1Nombre = revistaForm.Indice1Nombre,
                RevistaPublicacionIndice2Nombre = revistaForm.Indice2Nombre,
                RevistaPublicacionIndice3Nombre = revistaForm.Indice3Nombre
            };

            return Rjs("ChangeRevista", form);
        }

        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult NewCoautorInterno(int id)
        {
            var resena = resenaService.GetResenaById(id);
            var form = new CoautorForm {Controller = "Resena", IdName = "ResenaId"};

            if (resena != null)
                form.Id = resena.Id;

            return Rjs("NewCoautorInterno", form);
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddCoautorInterno([Bind(Prefix = "CoautorInterno")] CoautorInternoProductoForm form,
                                              int resenaId)
        {
            var coautorInternoResena = coautorInternoResenaMapper.Map(form);

            ModelState.AddModelErrors(coautorInternoResena.ValidationResults(), false, "CoautorInterno", String.Empty);
            if (!ModelState.IsValid)
            {
                return Rjs("ModelError");
            }

            coautorInternoResena.CreadorPor = CurrentUser();
            coautorInternoResena.ModificadoPor = CurrentUser();

            if (resenaId != 0)
            {
                var resena = resenaService.GetResenaById(resenaId);

                var alreadyHasIt =
                    resena.CoautorInternoResenas.Where(
                        x => x.Investigador.Id == coautorInternoResena.Investigador.Id).Count();

                if (alreadyHasIt == 0)
                {
                    resena.AddCoautorInterno(coautorInternoResena);
                    resenaService.SaveResena(resena);
                }
            }

            var coautorInternoResenaForm = coautorInternoResenaMapper.Map(coautorInternoResena);
            coautorInternoResenaForm.ParentId = resenaId;

            return Rjs("AddCoautorInterno", coautorInternoResenaForm);
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Delete)]
        public ActionResult DeleteCoautorInterno(int id, int investigadorId)
        {
            var resena = resenaService.GetResenaById(id);

            if (resena != null)
            {
                var coautor = resena.CoautorInternoResenas.Where(x => x.Investigador.Id == investigadorId).First();
                resena.DeleteCoautorInterno(coautor);

                resenaService.SaveResena(resena);
            }

            var form = new CoautorForm {ModelId = id, InvestigadorId = investigadorId};

            return Rjs("DeleteCoautorInterno", form);
        }

        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult NewCoautorExterno(int id)
        {
            var resena = resenaService.GetResenaById(id);
            var form = new CoautorForm { Controller = "Resena", IdName = "ResenaId", InvestigadorExterno = new InvestigadorExternoForm() };

            if (resena != null)
                form.Id = resena.Id;

            return Rjs("NewCoautorExterno", form);
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddCoautorExterno([Bind(Prefix = "CoautorExterno")] CoautorExternoProductoForm form,
                                              int resenaId)
        {
            var investigadorExternoForm = new InvestigadorExternoForm
                                              {
                                                  Nombre = form.InvestigadorExternoNombre,
                                                  ApellidoPaterno = form.InvestigadorExternoApellidoPaterno,
                                                  ApellidoMaterno = form.InvestigadorExternoApellidoMaterno
                                              };

            var investigadorExterno = investigadorExternoMapper.Map(investigadorExternoForm);

            ModelState.AddModelErrors(investigadorExterno.ValidationResults(), false, "CoautorExterno", String.Empty);
            if (!ModelState.IsValid)
            {
                return Rjs("ModelError");
            }

            investigadorExterno.CreadorPor = CurrentUser();
            investigadorExterno.ModificadoPor = CurrentUser();

            catalogoService.SaveInvestigadorExterno(investigadorExterno);

            investigadorExternoForm = investigadorExternoMapper.Map(investigadorExterno);

            form.InvestigadorExternoId = investigadorExternoForm.Id;
            var coautorExternoResena = coautorExternoResenaMapper.Map(form);

            ModelState.AddModelErrors(coautorExternoResena.ValidationResults(), false, "CoautorExterno", String.Empty);
            if (!ModelState.IsValid)
            {
                return Rjs("ModelError");
            }

            if (resenaId != 0)
            {
                coautorExternoResena.CreadorPor = CurrentUser();
                coautorExternoResena.ModificadoPor = CurrentUser();

                var resena = resenaService.GetResenaById(resenaId);

                var alreadyHasIt =
                    resena.CoautorExternoResenas.Where(
                        x => x.InvestigadorExterno.Id == coautorExternoResena.InvestigadorExterno.Id).Count();

                if (alreadyHasIt == 0)
                {
                    resena.AddCoautorExterno(coautorExternoResena);
                    resenaService.SaveResena(resena);
                }
            }

            var coautorExternoResenaForm = coautorExternoResenaMapper.Map(coautorExternoResena);
            coautorExternoResenaForm.ParentId = resenaId;

            return Rjs("AddCoautorExterno", coautorExternoResenaForm);
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Delete)]
        public ActionResult DeleteCoautorExterno(int id, int investigadorExternoId)
        {
            var resena = resenaService.GetResenaById(id);

            if (resena != null)
            {
                var coautor =
                    resena.CoautorExternoResenas.Where(x => x.InvestigadorExterno.Id == investigadorExternoId).First();
                resena.DeleteCoautorExterno(coautor);

                resenaService.SaveResena(resena);
            }

            var form = new CoautorForm {ModelId = id, InvestigadorExternoId = investigadorExternoId};

            return Rjs("DeleteCoautorExterno", form);
        }

        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult NewAutorInterno(int id)
        {
            var resena = resenaService.GetResenaById(id);
            var form = new AutorForm { Controller = "Resena", IdName = "ResenaId" };

            if (resena != null)
                form.Id = resena.Id;

            return Rjs("NewAutorInterno", form);
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddAutorInterno(
            [Bind(Prefix = "AutorInterno")] AutorInternoProductoForm form, int resenaId)
        {
            var autorInternoResena = autorInternoResenaMapper.Map(form);

            ModelState.AddModelErrors(autorInternoResena.ValidationResults(), false, "AutorInterno", String.Empty);
            if (!ModelState.IsValid)
            {
                return Rjs("ModelError");
            }

            if (resenaId != 0)
            {
                autorInternoResena.CreadorPor = CurrentUser();
                autorInternoResena.ModificadoPor = CurrentUser();

                var resena = resenaService.GetResenaById(resenaId);

                var alreadyHasIt =
                    resena.AutorInternoResenas.Where(
                        x => x.Investigador.Id == autorInternoResena.Investigador.Id).Count();

                if (alreadyHasIt == 0)
                {
                    resena.AddAutorInterno(autorInternoResena);
                    resenaService.SaveResena(resena);
                }
            }

            var autorInternoResenaForm = autorInternoResenaMapper.Map(autorInternoResena);
            autorInternoResenaForm.ParentId = resenaId;

            return Rjs("AddAutorInterno", autorInternoResenaForm);
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Delete)]
        public ActionResult DeleteAutorInterno(int id, int investigadorId)
        {
            var resena = resenaService.GetResenaById(id);

            if (resena != null)
            {
                var autor = resena.AutorInternoResenas.Where(x => x.Investigador.Id == investigadorId).First();
                resena.DeleteAutorInterno(autor);

                resenaService.SaveResena(resena);
            }

            var form = new AutorForm { ModelId = id, InvestigadorId = investigadorId };

            return Rjs("DeleteAutorInterno", form);
        }

        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult NewAutorExterno(int id)
        {
            var resena = resenaService.GetResenaById(id);

            var form = new AutorForm { Controller = "Resena", IdName = "ResenaId", InvestigadorExterno = new InvestigadorExternoForm()};

            if (resena != null)
                form.Id = resena.Id;

            return Rjs("NewAutorExterno", form);
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddAutorExterno(
            [Bind(Prefix = "AutorExterno")] AutorExternoProductoForm form, int resenaId)
        {
            var investigadorExternoForm = new InvestigadorExternoForm
            {
                Nombre = form.InvestigadorExternoNombre,
                ApellidoPaterno = form.InvestigadorExternoApellidoPaterno,
                ApellidoMaterno = form.InvestigadorExternoApellidoMaterno
            };

            var investigadorExterno = investigadorExternoMapper.Map(investigadorExternoForm);

            ModelState.AddModelErrors(investigadorExterno.ValidationResults(), false, "AutorExterno", String.Empty);
            if (!ModelState.IsValid)
            {
                return Rjs("ModelError");
            }

            investigadorExterno.CreadorPor = CurrentUser();
            investigadorExterno.ModificadoPor = CurrentUser();

            catalogoService.SaveInvestigadorExterno(investigadorExterno);

            investigadorExternoForm = investigadorExternoMapper.Map(investigadorExterno);

            form.InvestigadorExternoId = investigadorExternoForm.Id;
            var autorExternoResena = autorExternoResenaMapper.Map(form);

            ModelState.AddModelErrors(autorExternoResena.ValidationResults(), false, "AutorExterno", String.Empty);
            if (!ModelState.IsValid)
            {
                return Rjs("ModelError");
            }

            if (resenaId != 0)
            {
                autorExternoResena.CreadorPor = CurrentUser();
                autorExternoResena.ModificadoPor = CurrentUser();

                var resena = resenaService.GetResenaById(resenaId);

                var alreadyHasIt =
                    resena.AutorExternoResenas.Where(
                        x => x.InvestigadorExterno.Id == autorExternoResena.InvestigadorExterno.Id).Count();

                if (alreadyHasIt == 0)
                {
                    resena.AddAutorExterno(autorExternoResena);
                    resenaService.SaveResena(resena);
                }
            }

            var autorExternoResenaForm = autorExternoResenaMapper.Map(autorExternoResena);
            autorExternoResenaForm.ParentId = resenaId;

            return Rjs("AddAutorExterno", autorExternoResenaForm);
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Delete)]
        public ActionResult DeleteAutorExterno(int id, int investigadorExternoId)
        {
            var resena = resenaService.GetResenaById(id);

            if (resena != null)
            {
                var autor =
                    resena.AutorExternoResenas.Where(x => x.InvestigadorExterno.Id == investigadorExternoId).First();
                resena.DeleteAutorExterno(autor);

                resenaService.SaveResena(resena);
            }

            var form = new AutorForm { ModelId = id, InvestigadorExternoId = investigadorExternoId };

            return Rjs("DeleteAutorExterno", form);
        }

        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult NewEditorial(int id)
        {
            var resena = resenaService.GetResenaById(id);

            var form = new EditorialForm { Controller = "Resena", IdName = "ResenaId" };

            if (resena != null)
                form.Id = resena.Id;

            return Rjs("NewEditorial", form);
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddEditorial([Bind(Prefix = "Editorial")] EditorialProductoForm form, int resenaId)
        {
            var editorialResena = editorialResenaMapper.Map(form);

            ModelState.AddModelErrors(editorialResena.ValidationResults(), false, "Editorial", String.Empty);
            if (!ModelState.IsValid)
            {
                return Rjs("ModelError");
            }

            if (resenaId != 0)
            {
                editorialResena.CreadorPor = CurrentUser();
                editorialResena.ModificadoPor = CurrentUser();

                var resena = resenaService.GetResenaById(resenaId);

                var alreadyHasIt =
                    resena.EditorialResenas.Where(
                        x => x.Editorial.Id == editorialResena.Editorial.Id).Count();

                if (alreadyHasIt == 0)
                {
                    resena.AddEditorial(editorialResena);
                    resenaService.SaveResena(resena);
                }
            }

            var editorialResenaForm = editorialResenaMapper.Map(editorialResena);
            editorialResenaForm.ParentId = resenaId;

            return Rjs("AddEditorial", editorialResenaForm);
        }

        [CustomTransaction]
        [Authorize(Roles = "Investigadores")]
        [AcceptVerbs(HttpVerbs.Delete)]
        public ActionResult DeleteEditorial(int id, int editorialId)
        {
            var resena = resenaService.GetResenaById(id);

            if (resena != null)
            {
                var editorial = resena.EditorialResenas.Where(x => x.Editorial.Id == editorialId).First();
                resena.DeleteEditorial(editorial);

                resenaService.SaveResena(resena);
            }

            var form = new EditorialForm { ModelId = id, EditorialId = editorialId };

            return Rjs("DeleteEditorial", form);
        }

        ResenaForm SetupNewForm()
        {
            return SetupNewForm(null);
        }

        ResenaForm SetupNewForm(ResenaForm form)
        {
            form = form ?? new ResenaForm();

            form.TiposResenas = customCollection.TipoResenaCustomCollection();
            form.EstadosProductos = customCollection.EstadoProductoCustomCollection();
            form.Paises = paisMapper.Map(catalogoService.GetActivePaises());

            form.Areas = areaMapper.Map(catalogoService.GetActiveAreas());
            form.Disciplinas = GetDisciplinasByAreaId(form.AreaId);
            form.Subdisciplinas = GetSubdisciplinasByDisciplinaId(form.DisciplinaId);

            return form;
        }

        void FormSetCombos(ResenaForm form)
        {
            ViewData["TipoResena"] = form.TipoResena;
            ViewData["EstadoProducto"] = form.EstadoProducto;
            ViewData["Pais"] = form.PaisId;

            ViewData["AreaId"] = form.AreaId;
            ViewData["DisciplinaId"] = form.DisciplinaId;
            ViewData["SubdisciplinaId"] = form.SubdisciplinaId;
        }

        static ResenaForm SetupShowForm(ResenaForm form)
        {
            form = form ?? new ResenaForm();

            form.ShowFields = new ShowFieldsForm
                                  {
                                      RevistaPublicacionTitulo = form.RevistaPublicacion.Titulo,
                                      RevistaPublicacionInstitucionNombre = form.RevistaPublicacion.InstitucionNombre,
                                      RevistaPublicacionPaisNombre = form.RevistaPublicacion.PaisNombre,
                                      RevistaPublicacionIndice1Nombre = form.RevistaPublicacion.Indice1Nombre,
                                      RevistaPublicacionIndice2Nombre = form.RevistaPublicacion.Indice2Nombre,
                                      RevistaPublicacionIndice3Nombre = form.RevistaPublicacion.Indice3Nombre,

                                      SubdisciplinaNombre = form.SubdisciplinaNombre,
                                      DisciplinaNombre = form.DisciplinaNombre,
                                      AreaNombre = form.AreaNombre,

                                      IsShowForm = true,
                                      RevistaLabel = "Revista en que se publica"
                                  };

            return form;
        }
    }
}