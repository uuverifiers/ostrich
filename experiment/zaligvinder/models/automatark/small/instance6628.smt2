(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d*\.\d{2}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))
; freeIPaddrsRunner\+The\+password\+is\x3A
(assert (str.in_re X (str.to_re "freeIPaddrsRunner+The+password+is:\u{0a}")))
(check-sat)
