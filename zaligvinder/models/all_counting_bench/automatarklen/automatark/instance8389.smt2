(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; that.*CodeguruBrowser.*CasinoBladeisInsideupdate\.cgiHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "that") (re.* re.allchar) (str.to_re "CodeguruBrowser") (re.* re.allchar) (str.to_re "CasinoBladeisInsideupdate.cgiHost:\u{0a}")))))
; ^(GIR|[A-Z]\d[A-Z\d]??|[A-Z]{2}\d[A-Z\d]??)[ ]??(\d[A-Z]{2})$
(assert (str.in_re X (re.++ (re.union (str.to_re "GIR") (re.++ (re.range "A" "Z") (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9"))))) (re.opt (str.to_re " ")) (str.to_re "\u{0a}") (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")))))
; ^((0[123456789]|1[0-2])(0[1-3]|1[0-9]|2[0-9]))|((0[13456789]|1[0-2])(30))|((0[13578]|1[02])(31))$
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (re.++ (str.to_re "0") (re.range "1" "3")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")))) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "30")) (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "31"))))))
(assert (> (str.len X) 10))
(check-sat)
