(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/jlnp\.html$/U
(assert (str.in_re X (str.to_re "//jlnp.html/U\u{0a}")))
; \x2Fcs\x2Fpop4\x2FA-Spywww\x2Eyoogee\x2Ecom
(assert (str.in_re X (str.to_re "/cs/pop4/A-Spywww.yoogee.com\u{13}\u{0a}")))
; ^(20|23|27|30|33)-[0-9]{8}-[0-9]$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "20") (str.to_re "23") (str.to_re "27") (str.to_re "30") (str.to_re "33")) (str.to_re "-") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}")))))
; ^[a-zA-Z_:]+[a-zA-Z_:\-\.\d]*$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re ":"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re ":") (str.to_re "-") (str.to_re ".") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
