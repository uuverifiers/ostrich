/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
 */

package ostrich.automata

/** Exact structural certificate for one stop-on-character modulo extractor. */
case class ExtractorCertificate(period : Int, phase : Int, stop : Int) {
  require(period > 0, "an extractor period must be positive")
  require(phase >= 0 && phase < period,
          "an extractor phase must lie inside its period")
  require(stop >= Char.MinValue.toInt && stop <= Char.MaxValue.toInt,
          "the stop character must fit the OSTRICH alphabet")
}
