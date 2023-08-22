(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 62[0-9]{14,17}
(assert (str.in_re X (re.++ (str.to_re "62") ((_ re.loop 14 17) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; YWRtaW46cGFzc3dvcmQ[^\n\r]*DA[^\n\r]*Host\x3Awww\x2Ee-finder\x2Ecc
(assert (not (str.in_re X (re.++ (str.to_re "YWRtaW46cGFzc3dvcmQ") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "DA") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:www.e-finder.cc\u{0a}")))))
; Host\u{3a}searchresltwww\x2Ewordiq\x2Ecomwww2\u{2e}instantbuzz\u{2e}com
(assert (str.in_re X (str.to_re "Host:searchresltwww.wordiq.com\u{1b}www2.instantbuzz.com\u{0a}")))
; \x2Fxml\x2Ftoolbar\x2F
(assert (not (str.in_re X (str.to_re "/xml/toolbar/\u{0a}"))))
; Host\x3A\s+Agentbody=\u{25}21\u{25}21\u{25}21Optix
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Agentbody=%21%21%21Optix\u{13}\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
