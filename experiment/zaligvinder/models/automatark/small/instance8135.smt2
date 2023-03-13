(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; securityOmFkbWluADROARad\x2Emokead\x2Ecom\x3C\x2Fchat\x3E
(assert (str.in_re X (str.to_re "securityOmFkbWluADROARad.mokead.com</chat>\u{0a}")))
; /onload\s*\x3D\s*[\u{22}\u{27}]?location\.reload\s*\u{28}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/onload") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "location.reload") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(/smi\u{0a}")))))
; ^((6011)((-|\s)?[0-9]{4}){3})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}6011") ((_ re.loop 3 3) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9"))))))))
; www\x2EZSearchResults\x2Ecom\dBar.*sponsor2\.ucmore\.com
(assert (str.in_re X (re.++ (str.to_re "www.ZSearchResults.com\u{13}") (re.range "0" "9") (str.to_re "Bar") (re.* re.allchar) (str.to_re "sponsor2.ucmore.com\u{0a}"))))
; linkautomatici\x2Ecom\dBasic\d+Host\x3AFloodedFictionalUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "linkautomatici.com") (re.range "0" "9") (str.to_re "Basic") (re.+ (re.range "0" "9")) (str.to_re "Host:FloodedFictionalUser-Agent:\u{0a}")))))
(check-sat)
