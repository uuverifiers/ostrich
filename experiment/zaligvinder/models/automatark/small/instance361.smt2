(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{5}-\d{4}|\d{5})$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /\/modules\/\d\.jar$/U
(assert (not (str.in_re X (re.++ (str.to_re "//modules/") (re.range "0" "9") (str.to_re ".jar/U\u{0a}")))))
; /\/stat_n\/$/U
(assert (str.in_re X (str.to_re "//stat_n//U\u{0a}")))
(check-sat)
