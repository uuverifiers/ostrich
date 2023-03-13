(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([51|52|53|54|55]{2})([0-9]{14})$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "5") (str.to_re "1") (str.to_re "|") (str.to_re "2") (str.to_re "3") (str.to_re "4"))) ((_ re.loop 14 14) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
