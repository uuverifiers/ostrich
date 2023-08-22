// Automatically generated file
#ifndef __LP_PARAMS_HPP_
#define __LP_PARAMS_HPP_
#include "util/params.h"
#include "util/gparams.h"
struct lp_params {
  params_ref const & p;
  params_ref g;
  lp_params(params_ref const & _p = params_ref::get_empty()):
     p(_p), g(gparams::get_module("lp")) {}
  static void collect_param_descrs(param_descrs & d) {
    d.insert("rep_freq", CPK_UINT, "the report frequency, in how many iterations print the cost and other info ", "0","lp");
    d.insert("min", CPK_BOOL, "minimize cost", "false","lp");
    d.insert("print_stats", CPK_BOOL, "print statistic", "false","lp");
    d.insert("simplex_strategy", CPK_UINT, "simplex strategy for the solver", "0","lp");
    d.insert("enable_hnf", CPK_BOOL, "enable hnf cuts", "true","lp");
    d.insert("bprop_on_pivoted_rows", CPK_BOOL, "propagate bounds on rows changed by the pivot operation", "true","lp");
  }
  /*
     REG_MODULE_PARAMS('lp', 'lp_params::collect_param_descrs')
  */
  unsigned rep_freq() const { return p.get_uint("rep_freq", g, 0u); }
  bool min() const { return p.get_bool("min", g, false); }
  bool print_stats() const { return p.get_bool("print_stats", g, false); }
  unsigned simplex_strategy() const { return p.get_uint("simplex_strategy", g, 0u); }
  bool enable_hnf() const { return p.get_bool("enable_hnf", g, true); }
  bool bprop_on_pivoted_rows() const { return p.get_bool("bprop_on_pivoted_rows", g, true); }
};
#endif
