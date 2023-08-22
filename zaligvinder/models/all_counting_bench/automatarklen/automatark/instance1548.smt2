(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\x2F40e800[0-9A-F]{30,}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//40e800/Ui\u{0a}") ((_ re.loop 30 30) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F")))))))
(assert (> (str.len X) 10))
(check-sat)
