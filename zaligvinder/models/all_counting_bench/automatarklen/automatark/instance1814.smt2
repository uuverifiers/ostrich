(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\+)?(\d{2})[-])?(([\(])?((\d){3,5})([\)])?[-])|(\d{3,5})(\d{5,8}){1}?$
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-"))) (re.opt (str.to_re "(")) ((_ re.loop 3 5) (re.range "0" "9")) (re.opt (str.to_re ")")) (str.to_re "-")) (re.++ ((_ re.loop 3 5) (re.range "0" "9")) ((_ re.loop 1 1) ((_ re.loop 5 8) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; (^\d*\.\d{2}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))
; www\x2Ericercadoppia\x2Ecom\w+TPSystem\s+User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "www.ricercadoppia.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "TPSystem") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
