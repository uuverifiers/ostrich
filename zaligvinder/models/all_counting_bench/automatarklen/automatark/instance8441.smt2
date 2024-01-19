(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{4})[.](0{0,1}[1-9]|1[012])[.](0{0,1}[1-9]|[12][0-9]|3[01])[.](\d{2})$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re ".") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re ".") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; [0-9]{3}P[A-Z][0-9]{7}[0-9X]
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "P") (re.range "A" "Z") ((_ re.loop 7 7) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "X")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
