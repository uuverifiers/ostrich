(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([30|36|38]{2})([0-9]{12})$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "3") (str.to_re "0") (str.to_re "|") (str.to_re "6") (str.to_re "8"))) ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Logtraffbest\x2EbizAdToolsLogged
(assert (not (str.in_re X (str.to_re "Logtraffbest.bizAdToolsLogged\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
