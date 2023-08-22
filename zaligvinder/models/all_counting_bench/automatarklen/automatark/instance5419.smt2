(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ShadowNet\s+AID\x2FUser-Agent\x3AFen\u{ea}treEye\x2Fdss\x2Fcc\.2_0_0\.
(assert (str.in_re X (re.++ (str.to_re "ShadowNet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AID/User-Agent:Fen\u{ea}treEye/dss/cc.2_0_0.\u{0a}"))))
; /\/setup\/[a-z0-9!-]{50}/Ui
(assert (str.in_re X (re.++ (str.to_re "//setup/") ((_ re.loop 50 50) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "!") (str.to_re "-"))) (str.to_re "/Ui\u{0a}"))))
; (^[+]?\d*\.?\d*[1-9]+\d*$)|(^[+]?[1-9]+\d*\.\d*$)
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "+")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "+")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
