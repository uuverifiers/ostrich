(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; -[0-9]*[x][0-9]*
(assert (str.in_re X (re.++ (str.to_re "-") (re.* (re.range "0" "9")) (str.to_re "x") (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\r\nHost\u{3a}\u{20}[a-z0-9\u{2d}\u{2e}]+\.com\u{2d}[a-z0-9\u{2d}\u{2e}]+(\u{3a}\d{1,5})?\r\n/Hi
(assert (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}Host: ") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".com-") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "\u{0d}\u{0a}/Hi\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
