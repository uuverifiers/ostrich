(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{1,2})(\s?(H|h)?)(:([0-5]\d))?$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "H") (str.to_re "h")))))))
; ^(((\(\d{3}\)|\d{3})( |-|\.))|(\(\d{3}\)|\d{3}))?\d{3}( |-|\.)?\d{4}(( |-|\.)?([Ee]xt|[Xx])[.]?( |-|\.)?\d{4})?$
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) (re.union (re.++ (re.union (str.to_re "E") (str.to_re "e")) (str.to_re "xt")) (str.to_re "X") (str.to_re "x")) (re.opt (str.to_re ".")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)
