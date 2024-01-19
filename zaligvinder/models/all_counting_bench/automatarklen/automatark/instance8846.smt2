(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b[A-Z0-9]{5}\d{1}[01567]\d{1}([0][1-9]|[12][0-9]|[3][0-1])\d{1}[A-Z0-9]{3}[A-Z]{2}\b
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "0" "9")) (re.union (str.to_re "0") (str.to_re "1") (str.to_re "5") (str.to_re "6") (str.to_re "7")) ((_ re.loop 1 1) (re.range "0" "9")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; (^[0-9]*[1-9]+[0-9]*\.[0-9]*$)|(^[0-9]*\.[0-9]*[1-9]+[0-9]*$)|(^[0-9]*[1-9]+[0-9]*$)
(assert (str.in_re X (re.union (re.++ (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))))))
; \b(0?[1-9]|1[0-2])(\/)(0?[1-9]|1[0-9]|2[0-9]|3[0-1])(\/)(200[0-8])\b
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/\u{0a}200") (re.range "0" "8"))))
(assert (> (str.len X) 10))
(check-sat)
