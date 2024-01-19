(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+ulmxct\u{2f}mqoyc\s+securityOmFkbWluADROARad\x2Emokead\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ulmxct/mqoyc") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "securityOmFkbWluADROARad.mokead.com\u{0a}"))))
; /^\/[a-f0-9]{32}\.php\?q=[a-f0-9]{32}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".php?q=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; ^(0|([1-9]\d{0,3}|[1-5]\d{4}|[6][0-5][0-5]([0-2]\d|[3][0-5])))$
(assert (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "5") (re.range "0" "5") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "5"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
