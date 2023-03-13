(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/software\u{2e}php\u{3f}[0-9]{15,}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//software.php?/Ui\u{0a}") ((_ re.loop 15 15) (re.range "0" "9")) (re.* (re.range "0" "9"))))))
(check-sat)
