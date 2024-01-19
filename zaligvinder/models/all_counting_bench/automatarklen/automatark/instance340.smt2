(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; sidesearch\.dropspam\.com\s+Strip-Player\s+
(assert (str.in_re X (re.++ (str.to_re "sidesearch.dropspam.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Strip-Player\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ((IT|LV)-?)?[0-9]{11}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "IT") (str.to_re "LV")) (re.opt (str.to_re "-")))) ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ad\x2Emokead\x2Ecom\d+Spy\d+ZOMBIES\u{5f}HTTP\u{5f}GETearch\x2Eearthlinkwww\x2Epurityscan\x2EcomUser-Agent\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "ad.mokead.com") (re.+ (re.range "0" "9")) (str.to_re "Spy") (re.+ (re.range "0" "9")) (str.to_re "ZOMBIES_HTTP_GETearch.earthlinkwww.purityscan.comUser-Agent:\u{0a}")))))
; /filename=[^\n]*\u{2e}asx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".asx/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
