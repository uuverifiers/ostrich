(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]{4})([0-9]{5})([0-9]{1})$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \sKeylogging\s+ApofisToolbar
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Keylogging\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ApofisToolbar\u{0a}")))))
; \(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\)
(assert (str.in_re X (re.++ (str.to_re "(") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ")\u{0a}"))))
; ProjectMyWebSearchSearchAssistantfast-look\x2EcomOneReporter
(assert (str.in_re X (str.to_re "ProjectMyWebSearchSearchAssistantfast-look.comOneReporter\u{0a}")))
; Pleasetvshowticketsmedia\x2Edxcdirect\x2Ecom\x2Fbar_pl\x2Fchk\.fcgi
(assert (not (str.in_re X (str.to_re "Pleasetvshowticketsmedia.dxcdirect.com/bar_pl/chk.fcgi\u{0a}"))))
(check-sat)
