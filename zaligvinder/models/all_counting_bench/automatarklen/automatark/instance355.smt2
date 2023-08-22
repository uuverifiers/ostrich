(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([+]\d{2}[ ][1-9]\d{0,2}[ ])|([0]\d{1,3}[-]))((\d{2}([ ]\d{2}){2})|(\d{3}([ ]\d{3})*([ ]\d{2})+))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "+") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re " ")) (re.++ (str.to_re "0") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "-"))) (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.* (re.++ (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")))) (re.+ (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
