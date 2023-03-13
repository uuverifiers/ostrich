(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/html\/license_[0-9A-F]{550,}\.html$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//html/license_.html/Ui\u{0a}") ((_ re.loop 550 550) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F")))))))
(check-sat)
