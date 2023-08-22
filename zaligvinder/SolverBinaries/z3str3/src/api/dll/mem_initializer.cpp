// Automatically generated file.
#include "util/debug.h"
#include "util/gparams.h"
#include "util/prime_generator.h"
#include "util/rational.h"
#include "util/rlimit.h"
#include "util/symbol.h"
#include "util/trace.h"
void mem_initialize() {
prime_iterator::initialize();
rational::initialize();
initialize_rlimit();
initialize_symbols();
gparams::init();
}
void mem_finalize() {
finalize_debug();
gparams::finalize();
prime_iterator::finalize();
rational::finalize();
finalize_rlimit();
finalize_symbols();
finalize_trace();
}
