(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(F-)?((2[A|B])|[0-9]{2})[0-9]{3}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "F-")) (re.union (re.++ (str.to_re "2") (re.union (str.to_re "A") (str.to_re "|") (str.to_re "B"))) ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; [D]?[-D]?[0-9]{5}
(assert (str.in_re X (re.++ (re.opt (str.to_re "D")) (re.opt (re.union (str.to_re "-") (str.to_re "D"))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
