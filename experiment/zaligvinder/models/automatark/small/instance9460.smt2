(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\W{0,5}[Rr]e:\W[a-zA-Z0-9]{1,10},\W[a-z]{1,10}\W[a-z]{1,10}\W[a-z]{1,10}
(assert (str.in_re X (re.++ ((_ re.loop 0 5) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "R") (str.to_re "r")) (str.to_re "e:") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ",") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (str.to_re "\u{0a}"))))
; (Word1|Word2).*?(10|[1-9])
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "10") (re.range "1" "9")) (str.to_re "\u{0a}Word") (re.union (str.to_re "1") (str.to_re "2"))))))
; ^((1[01])|(\d)):[0-5]\d(:[0-5]\d)?\s?([apAP][Mm])?$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9")) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.union (str.to_re "a") (str.to_re "p") (str.to_re "A") (str.to_re "P")) (re.union (str.to_re "M") (str.to_re "m")))) (str.to_re "\u{0a}"))))
(check-sat)
