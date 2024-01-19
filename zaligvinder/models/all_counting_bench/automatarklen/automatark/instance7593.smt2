(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]|[a-z]){4} ?[0-9]{6}-?[0-9]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re " ")) ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; corep\x2Edmcast\x2Ecom[^\n\r]*Referer\u{3a}.*is[^\n\r]*KeyloggerExplorerfileserverSI\|Server\|www\x2Emyarmory\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "corep.dmcast.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Referer:") (re.* re.allchar) (str.to_re "is") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "KeyloggerExplorerfileserverSI|Server|\u{13}www.myarmory.com\u{0a}")))))
; Host\x3AAddressDaemonUser-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (str.to_re "Host:AddressDaemonUser-Agent:User-Agent:\u{0a}"))))
; /filename=[^\n]*\u{2e}visprj/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".visprj/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
