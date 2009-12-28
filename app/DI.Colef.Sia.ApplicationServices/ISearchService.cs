﻿using System;
using System.Linq.Expressions;
using DecisionesInteligentes.Colef.Sia.Core;

namespace DecisionesInteligentes.Colef.Sia.ApplicationServices
{
    public interface ISearchService
    {
        string Search<TEntity>(Expression<Func<TEntity, object>> expression, string value);
        string SearchInvestigador(string value);
        string SearchUsuario(string value);
        string SearchMovilidadAcademica(string value);
        string SearchApoyoConacyt(string value);
        string SearchIdiomaInvestigador(string value);
        string SearchInvestigador(string value, int investigadorId);
        string SearchOrganoInterno(string value);
        string SearchRevistaTipoABC(string value);
        string SearchRevistaTipoD(string value);
    }
}
