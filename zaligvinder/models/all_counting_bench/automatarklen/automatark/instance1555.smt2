(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^/{1}(((/{1}\.{1})?[a-zA-Z0-9 ]+/?)+(\.{1}[a-zA-Z0-9]{2,4})?)$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "/")) (str.to_re "\u{0a}") (re.+ (re.++ (re.opt (re.++ ((_ re.loop 1 1) (str.to_re "/")) ((_ re.loop 1 1) (str.to_re ".")))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " "))) (re.opt (str.to_re "/")))) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))))))))
; /\/[a-zA-Z_-]+\.ee$/U
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "-"))) (str.to_re ".ee/U\u{0a}"))))
; \x2APORT2\x2Acdpnode=Host\x3A
(assert (not (str.in_re X (str.to_re "*PORT2*cdpnode=Host:\u{0a}"))))
; Theef2offers\x2Ebullseye-network\x2Ecom
(assert (str.in_re X (str.to_re "Theef2offers.bullseye-network.com\u{0a}")))
; /[^\u{0d}\u{0a}\u{09}\u{20}-\u{7e}]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "\u{09}") (re.range " " "~"))) (str.to_re "/P\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
