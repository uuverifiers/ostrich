(declare-const x String)
(assert (str.in.re x (re.* (str.to.re "h"))))
(assert (> 0 (str.to.int x)))
(check-sat)
