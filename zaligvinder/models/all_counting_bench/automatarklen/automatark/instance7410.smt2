(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Fcommunicatortb[^\n\r]*\x2FGR.*Reportinfowhenu\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "/communicatortb") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "/GR") (re.* re.allchar) (str.to_re "Reportinfowhenu.com\u{13}\u{0a}"))))
; /\/html\/license_[0-9A-F]{550,}\.html$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//html/license_.html/Ui\u{0a}") ((_ re.loop 550 550) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F")))))))
; \/cgi-bin\/PopupV\s+insert.*Host\u{3a}HELOHourssurvey\.asp\?nUserId=
(assert (not (str.in_re X (re.++ (str.to_re "/cgi-bin/PopupV") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "insert") (re.* re.allchar) (str.to_re "Host:HELOHourssurvey.asp?nUserId=\u{0a}")))))
; com\dsearch\u{2e}conduit\u{2e}com\s+User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "com") (re.range "0" "9") (str.to_re "search.conduit.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}"))))
; /\u{2e}ttf([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.ttf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
