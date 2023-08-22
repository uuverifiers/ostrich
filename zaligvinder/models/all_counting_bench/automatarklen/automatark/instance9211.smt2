(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}jpx([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jpx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /\/[0-9A-F]{24}/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/Ui\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
