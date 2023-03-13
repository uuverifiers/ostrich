(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/\[fx]\.jar$/U
(assert (not (str.in_re X (str.to_re "//[fx].jar/U\u{0a}"))))
; ^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "1" "9")) (re.++ (re.range "0" "9") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
