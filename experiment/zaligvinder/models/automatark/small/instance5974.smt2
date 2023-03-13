(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; asdbiz\x2Ebiz\s+informationHost\x3A
(assert (str.in_re X (re.++ (str.to_re "asdbiz.biz") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "informationHost:\u{0a}"))))
; ^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "V") (str.to_re "X") (str.to_re "Y"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")) (re.* (str.to_re " ")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
