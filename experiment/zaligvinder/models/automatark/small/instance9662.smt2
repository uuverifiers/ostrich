(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; NetControl\x2EServerNetTrackerSiLENTHost\x3A
(assert (not (str.in_re X (str.to_re "NetControl.Server\u{13}NetTrackerSiLENTHost:\u{0a}"))))
; ^[2-7]{1}[0-9]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "2" "7")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
