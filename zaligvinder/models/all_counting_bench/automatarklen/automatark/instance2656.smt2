(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/home\/index.asp\?typeid\=[0-9]{1,3}/Ui
(assert (str.in_re X (re.++ (str.to_re "//home/index") re.allchar (str.to_re "asp?typeid=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; /\u{2e}afm([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.afm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
