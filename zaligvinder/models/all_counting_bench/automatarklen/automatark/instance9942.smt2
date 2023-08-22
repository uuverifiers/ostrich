(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\+{1,2}?([0-9]{2,4}|\([0-9]{2,4}\))?(-|\s)?)?[0-9]{2,3}(-|\s)?[0-9\-]{5,10}$
(assert (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 1 2) (str.to_re "+")) (re.opt (re.union ((_ re.loop 2 4) (re.range "0" "9")) (re.++ (str.to_re "(") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re ")")))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 5 10) (re.union (re.range "0" "9") (str.to_re "-"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
