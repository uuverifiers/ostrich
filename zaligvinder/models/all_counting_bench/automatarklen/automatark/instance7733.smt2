(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; requested.*zmnjgmomgbdz\u{2f}zzmw\.gzt\s+Reportsdaosearch\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "requested") (re.* re.allchar) (str.to_re "zmnjgmomgbdz/zzmw.gzt") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Reportsdaosearch.com\u{0a}")))))
; ToolbarBasedATLRemoteFrom\x3Adcww\x2Edmcast\x2Ecom
(assert (str.in_re X (str.to_re "ToolbarBasedATLRemoteFrom:dcww.dmcast.com\u{0a}")))
; (^[0-9]{1,8}|(^[0-9]{1,8}\.{0,1}[0-9]{1,2}))$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 8) (re.range "0" "9")) (re.++ ((_ re.loop 1 8) (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
