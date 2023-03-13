(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/Java([0-9]{1,2})?\.jar\?java=[0-9]{2}/U
(assert (str.in_re X (re.++ (str.to_re "//Java") (re.opt ((_ re.loop 1 2) (re.range "0" "9"))) (str.to_re ".jar?java=") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; ^[A-Z]{4}[1-8](\d){2}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) (re.range "1" "8") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^((0[1-9])|(1[0-2]))\/(\d{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\/modules\/\d\.jar$/U
(assert (str.in_re X (re.++ (str.to_re "//modules/") (re.range "0" "9") (str.to_re ".jar/U\u{0a}"))))
(check-sat)
