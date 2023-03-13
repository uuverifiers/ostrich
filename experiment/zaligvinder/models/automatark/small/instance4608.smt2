(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^dir=[0-9A-F]{8}(-[0-9A-F]{4}){4}[0-9A-F]{8}&data=/Pi
(assert (not (str.in_re X (re.++ (str.to_re "/dir=") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) ((_ re.loop 4 4) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))))) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "&data=/Pi\u{0a}")))))
(check-sat)
