(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\u{3a}etbuviaebe\u{2f}eqv\.bvv
(assert (str.in_re X (str.to_re "User-Agent:etbuviaebe/eqv.bvv\u{0a}")))
; /\/software\u{2e}php\u{3f}[0-9]{15,}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//software.php?/Ui\u{0a}") ((_ re.loop 15 15) (re.range "0" "9")) (re.* (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
