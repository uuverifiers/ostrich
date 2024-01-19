(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 12/err
(assert (str.in_re X (str.to_re "12/err\u{0a}")))
; ^([a-z|A-Z]{1}[0-9]{3})[-]([0-9]{3})[-]([0-9]{2})[-]([0-9]{3})[-]([0-9]{1})
(assert (not (str.in_re X (re.++ (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (re.range "a" "z") (str.to_re "|") (re.range "A" "Z"))) ((_ re.loop 3 3) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
