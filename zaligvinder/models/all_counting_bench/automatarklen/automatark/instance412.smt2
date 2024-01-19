(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/home\/index.asp\?typeid\=[0-9]{1,3}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//home/index") re.allchar (str.to_re "asp?typeid=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
