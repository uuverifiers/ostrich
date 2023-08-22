(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((0[1-9])|(1[02]))/\d{2}
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; User-Agent\x3A\d+Theef2\sHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "Theef2") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}")))))
; ((X|x):-?(180(\.0+)?|[0-1]?[0-7]?[0-9](\.\d+)?))([ ]|,)*((Y|y):-?(90(\.0+)?|[0-8]?[0-9](\.\d+)?))
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re ","))) (str.to_re "\u{0a}") (re.union (str.to_re "X") (str.to_re "x")) (str.to_re ":") (re.opt (str.to_re "-")) (re.union (re.++ (str.to_re "180") (re.opt (re.++ (str.to_re ".") (re.+ (str.to_re "0"))))) (re.++ (re.opt (re.range "0" "1")) (re.opt (re.range "0" "7")) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (re.union (str.to_re "Y") (str.to_re "y")) (str.to_re ":") (re.opt (str.to_re "-")) (re.union (re.++ (str.to_re "90") (re.opt (re.++ (str.to_re ".") (re.+ (str.to_re "0"))))) (re.++ (re.opt (re.range "0" "8")) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))))))))
(assert (> (str.len X) 10))
(check-sat)
