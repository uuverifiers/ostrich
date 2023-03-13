(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1][0-9]|[0-9])[1-9]{2}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "9")) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "\u{0a}"))))
; My\x2Fdesktop\x2FWinSessionHost\u{3a}OnlineTPSystem\x7D\x7C
(assert (str.in_re X (str.to_re "My/desktop/WinSessionHost:OnlineTPSystem}|\u{0a}")))
(check-sat)
