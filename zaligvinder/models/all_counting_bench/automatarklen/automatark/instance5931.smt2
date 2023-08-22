(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([$])?((([0-9]{1,3},)+[0-9]{3})|[0-9]+)(\.[0-9]{2})?)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "$")) (re.union (re.++ (re.+ (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))))
; DigExt.*\u{23}\u{23}\u{23}\u{23}
(assert (str.in_re X (re.++ (str.to_re "DigExt") (re.* re.allchar) (str.to_re "####\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
