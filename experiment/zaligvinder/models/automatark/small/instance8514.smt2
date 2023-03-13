(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; &[a-zA-Z]+\d{0,3};
(assert (str.in_re X (re.++ (str.to_re "&") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re ";\u{0a}"))))
; [0-9]*\.?[0-9]*[1-9]
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.range "1" "9") (str.to_re "\u{0a}"))))
(check-sat)
