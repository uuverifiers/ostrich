(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9A-Za-z@.]{1,255})$
(assert (str.in_re X (re.++ ((_ re.loop 1 255) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "@") (str.to_re "."))) (str.to_re "\u{0a}"))))
; <link href="../Common/Styles/iLienStyle.css" type="text/css" rel="stylesheet" />
(assert (str.in_re X (re.++ (str.to_re "<link href=\u{22}") re.allchar re.allchar (str.to_re "/Common/Styles/iLienStyle") re.allchar (str.to_re "css\u{22} type=\u{22}text/css\u{22} rel=\u{22}stylesheet\u{22} />\u{0a}"))))
(check-sat)
