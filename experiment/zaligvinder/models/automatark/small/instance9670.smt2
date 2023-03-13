(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9.\-/+() ]{4,}
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "-") (str.to_re "/") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " "))) (re.* (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "-") (str.to_re "/") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " "))))))
; /filename=[^\n]*\u{2e}dbp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dbp/i\u{0a}"))))
; corep\x2Edmcast\x2Ecom[^\n\r]*Referer\u{3a}.*is[^\n\r]*KeyloggerExplorerfileserverSI\|Server\|www\x2Emyarmory\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "corep.dmcast.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Referer:") (re.* re.allchar) (str.to_re "is") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "KeyloggerExplorerfileserverSI|Server|\u{13}www.myarmory.com\u{0a}"))))
; ^(\d*\s*\-?\s*\d*)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.range "0" "9"))))))
(check-sat)
