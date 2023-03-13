(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^UA-\d+-\d+$
(assert (str.in_re X (re.++ (str.to_re "UA-") (re.+ (re.range "0" "9")) (str.to_re "-") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /[0-9A-Z]{8}\u{3a}bpass\u{0a}/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "Z"))) (str.to_re ":bpass\u{0a}/\u{0a}")))))
(check-sat)
