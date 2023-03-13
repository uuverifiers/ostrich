(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z]{4}\.html\?h\=\d{6,7}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".html?h=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; trustyfiles\x2Ecom\d+lnzzlnbk\u{2f}pkrm\.fin\s+
(assert (str.in_re X (re.++ (str.to_re "trustyfiles.com") (re.+ (re.range "0" "9")) (str.to_re "lnzzlnbk/pkrm.fin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ProAgentHost\u{3a}Host\x3AiOpuss_sq=aolsnssigninwininet
(assert (str.in_re X (str.to_re "ProAgentHost:Host:iOpuss_sq=aolsnssigninwininet\u{0a}")))
(check-sat)
