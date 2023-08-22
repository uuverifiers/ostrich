(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (NL-?)?[0-9]{9}B[0-9]{2}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "NL") (re.opt (str.to_re "-")))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "B") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; welcome\s+Host\x3A\s+ThistoIpHost\x3Abadurl\x2Egrandstreetinteractive\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "welcome") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ThistoIpHost:badurl.grandstreetinteractive.com\u{0a}")))))
; Referer\x3Awww\x2Eccnnlc\x2Ecom\u{04}\u{00}User-Agent\x3A\u{22}The
(assert (str.in_re X (str.to_re "Referer:www.ccnnlc.com\u{13}\u{04}\u{00}User-Agent:\u{22}The\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
