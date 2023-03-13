(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/lists\/\d{20}$/U
(assert (str.in_re X (re.++ (str.to_re "//lists/") ((_ re.loop 20 20) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; ^(#){1}([a-fA-F0-9]){6}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "#")) ((_ re.loop 6 6) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; filename=\u{22}Subject\u{3a}www\x2Eadoptim\x2Ecomreport\x2Fbar_pl\x2Fchk\.fcgi
(assert (str.in_re X (str.to_re "filename=\u{22}Subject:www.adoptim.comreport/bar_pl/chk.fcgi\u{0a}")))
(check-sat)
