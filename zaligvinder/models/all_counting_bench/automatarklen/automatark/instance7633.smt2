(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{1,3}([,]\d{3})*$)|(^\d{1,16}$)
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 16) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; [a-zA-Z]*( [a-zA-Z]*)?
(assert (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re " ") (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
; /\u{2f}ib2\u{2f}$/U
(assert (not (str.in_re X (str.to_re "//ib2//U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
