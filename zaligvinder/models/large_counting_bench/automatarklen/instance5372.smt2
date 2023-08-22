(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; cash loans, long term loans, unsecured loans, 12 month loans, bad credit loans,
(assert (not (str.in_re X (str.to_re "cash loans, long term loans, unsecured loans, 12 month loans, bad credit loans,\u{0a}"))))
; Subject\x3A[^\n\r]*Arrow[^\n\r]*whenu\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Arrow") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "whenu.com\u{13}\u{0a}")))))
; /filename=[^\n]*\u{2e}k3g/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".k3g/i\u{0a}")))))
; www\x2Eserverlogic3\x2Ecom\d+ToolBar\s+HWAEUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "www.serverlogic3.com") (re.+ (re.range "0" "9")) (str.to_re "ToolBar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HWAEUser-Agent:\u{0a}")))))
; /^[a-z]\x3D[0-9a-z]{100}$/Pm
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 100 100) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "/Pm\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
