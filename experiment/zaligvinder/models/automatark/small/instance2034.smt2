(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; corep\x2Edmcast\x2Ecom[^\n\r]*Referer\u{3a}.*is[^\n\r]*KeyloggerExplorerfileserverSI\|Server\|www\x2Emyarmory\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "corep.dmcast.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Referer:") (re.* re.allchar) (str.to_re "is") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "KeyloggerExplorerfileserverSI|Server|\u{13}www.myarmory.com\u{0a}"))))
; %3fc=UI2GmbHbacktrust\x2EcomSpediaReferer\x3ASubject\u{3a}Host\u{3a}passcorrect\x3B
(assert (not (str.in_re X (str.to_re "%3fc=UI2GmbHbacktrust.comSpediaReferer:Subject:Host:passcorrect;\u{0a}"))))
; /\/ddd\/[a-z]{2}.gif/iU
(assert (str.in_re X (re.++ (str.to_re "//ddd/") ((_ re.loop 2 2) (re.range "a" "z")) re.allchar (str.to_re "gif/iU\u{0a}"))))
; Host\x3A\dwww\x2Etrustedsearch\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "www.trustedsearch.com\u{0a}")))))
(check-sat)
