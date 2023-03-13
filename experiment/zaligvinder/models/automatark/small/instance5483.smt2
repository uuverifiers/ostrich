(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{2}
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /^[A-Z]{3}[G|A|F|C|T|H|P]{1}[A-Z]{1}\d{4}[A-Z]{1}$/;
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 1 1) (re.union (str.to_re "G") (str.to_re "|") (str.to_re "A") (str.to_re "F") (str.to_re "C") (str.to_re "T") (str.to_re "H") (str.to_re "P"))) ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")) (str.to_re "/;\u{0a}")))))
(check-sat)
