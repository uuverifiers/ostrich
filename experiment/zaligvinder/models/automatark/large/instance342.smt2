(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \A([0-9a-zA-Z_]{1,15})|(@([0-9a-zA-Z_]{1,15}))\Z
(assert (not (str.in_re X (re.union ((_ re.loop 1 15) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (re.++ (str.to_re "\u{0a}@") ((_ re.loop 1 15) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))))))))
; User-Agent\x3A\d+Theef2\sHost\x3A
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "Theef2") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}"))))
; ^\W{0,5}[Rr]e:\W[a-zA-Z0-9]{1,10},\W[a-z]{1,10}\W[a-z]{1,10}\W[a-z]{1,10}
(assert (str.in_re X (re.++ ((_ re.loop 0 5) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "R") (str.to_re "r")) (str.to_re "e:") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ",") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (str.to_re "\u{0a}"))))
; ^([a-zA-Z0-9])+\\{1}([a-zA-Z0-9])+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re "\u{5c}")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
