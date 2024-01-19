(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/3\/[A-Z]{2}\/[a-f0-9]{32}\.djvu/
(assert (str.in_re X (re.++ (str.to_re "//3/") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".djvu/\u{0a}"))))
; ^((00|\+)49)?(0?[2-9][0-9]{1,})$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "00") (str.to_re "+")) (str.to_re "49"))) (str.to_re "\u{0a}") (re.opt (str.to_re "0")) (re.range "2" "9") (re.+ (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
