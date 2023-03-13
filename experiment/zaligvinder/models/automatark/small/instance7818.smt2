(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[[V|E|J|G]\d\d\d\d\d\d\d\d]{0,9}$
(assert (str.in_re X (re.++ (re.union (str.to_re "[") (str.to_re "V") (str.to_re "|") (str.to_re "E") (str.to_re "J") (str.to_re "G")) (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") ((_ re.loop 0 9) (str.to_re "]")) (str.to_re "\u{0a}"))))
(check-sat)
