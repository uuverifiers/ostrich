(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; addrwww\x2Etrustedsearch\x2EcomX-Mailer\x3A
(assert (not (str.in_re X (str.to_re "addrwww.trustedsearch.comX-Mailer:\u{13}\u{0a}"))))
; ^(\d){8}$
(assert (not (str.in_re X (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(5[1-5]\d{2})\d{12}|(4\d{3})(\d{12}|\d{9})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "5") (re.range "1" "5") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 9 9) (re.range "0" "9"))) (str.to_re "\u{0a}4") ((_ re.loop 3 3) (re.range "0" "9")))))))
; this\w+c\.goclick\.com\d
(assert (str.in_re X (re.++ (str.to_re "this") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "c.goclick.com") (re.range "0" "9") (str.to_re "\u{0a}"))))
(check-sat)
