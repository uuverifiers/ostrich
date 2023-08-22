(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((X|x):-?(180(\.0+)?|[0-1]?[0-7]?[0-9](\.\d+)?))([ ]|,)*((Y|y):-?(90(\.0+)?|[0-8]?[0-9](\.\d+)?))
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re ","))) (str.to_re "\u{0a}") (re.union (str.to_re "X") (str.to_re "x")) (str.to_re ":") (re.opt (str.to_re "-")) (re.union (re.++ (str.to_re "180") (re.opt (re.++ (str.to_re ".") (re.+ (str.to_re "0"))))) (re.++ (re.opt (re.range "0" "1")) (re.opt (re.range "0" "7")) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (re.union (str.to_re "Y") (str.to_re "y")) (str.to_re ":") (re.opt (str.to_re "-")) (re.union (re.++ (str.to_re "90") (re.opt (re.++ (str.to_re ".") (re.+ (str.to_re "0"))))) (re.++ (re.opt (re.range "0" "8")) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))))))))
; /^[a-z][\w\.]+@([\w\-]+\.)+[a-z]{2,7}$/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (re.+ (re.union (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "."))) ((_ re.loop 2 7) (re.range "a" "z")) (str.to_re "/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
