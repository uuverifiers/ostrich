(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (str.to_re "\u{0a}")))))
; Host\x3A\s+offers\x2Ebullseye-network\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "offers.bullseye-network.com\u{0a}"))))
; /^[A-Z]{3}[G|A|F|C|T|H|P]{1}[A-Z]{1}\d{4}[A-Z]{1}$/;
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 1 1) (re.union (str.to_re "G") (str.to_re "|") (str.to_re "A") (str.to_re "F") (str.to_re "C") (str.to_re "T") (str.to_re "H") (str.to_re "P"))) ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")) (str.to_re "/;\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
