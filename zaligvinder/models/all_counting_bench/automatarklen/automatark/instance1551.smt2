(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; / \x2D .{1,20}\u{07}(LAN|PROXY|MODEM|MODEM BUSY|UNKNOWN)\u{07}Win/
(assert (not (str.in_re X (re.++ (str.to_re "/ - ") ((_ re.loop 1 20) re.allchar) (str.to_re "\u{07}") (re.union (str.to_re "LAN") (str.to_re "PROXY") (str.to_re "MODEM") (str.to_re "MODEM BUSY") (str.to_re "UNKNOWN")) (str.to_re "\u{07}Win/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
