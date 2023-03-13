(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{3}-\d{2}-\d{4})|(\d{3}\d{2}\d{4})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")))))))
; iz=iMeshBar%3f\x2Fbar_pl\x2Fchk_bar\.fcgi
(assert (str.in_re X (str.to_re "iz=iMeshBar%3f/bar_pl/chk_bar.fcgi\u{0a}")))
; \.?[a-zA-Z0-9]{1,}$
(assert (str.in_re X (re.++ (re.opt (str.to_re ".")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
