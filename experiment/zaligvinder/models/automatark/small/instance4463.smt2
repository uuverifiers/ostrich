(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\u{3a}User-Agent\x3AReport\x2EHost\x3Afhfksjzsfu\u{2f}ahm\.uqs
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:Report.Host:fhfksjzsfu/ahm.uqs\u{0a}"))))
; ((\d{2})|(\d))\/((\d{2})|(\d))\/((\d{4})|(\d{2}))
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.range "0" "9")) (str.to_re "/") (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.range "0" "9")) (str.to_re "/") (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^(((\(\d{3}\)|\d{3})( |-|\.))|(\(\d{3}\)|\d{3}))?\d{3}( |-|\.)?\d{4}(( |-|\.)?([Ee]xt|[Xx])[.]?( |-|\.)?\d{4})?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) (re.union (re.++ (re.union (str.to_re "E") (str.to_re "e")) (str.to_re "xt")) (str.to_re "X") (str.to_re "x")) (re.opt (str.to_re ".")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^[1-9]0?$
(assert (str.in_re X (re.++ (re.range "1" "9") (re.opt (str.to_re "0")) (str.to_re "\u{0a}"))))
(check-sat)
