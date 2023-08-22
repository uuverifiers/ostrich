(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-f0-9]{32}\/[a-z]{1,15}-[a-z]{1,15}\.php/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 1 15) (re.range "a" "z")) (str.to_re "-") ((_ re.loop 1 15) (re.range "a" "z")) (str.to_re ".php/U\u{0a}")))))
; nick_name=CIA-Test\s+User-Agent\x3A\s+Downloadfowclxccdxn\u{2f}uxwn\.ddywww\x2Eeasymessage\x2Enet
(assert (str.in_re X (re.++ (str.to_re "nick_name=CIA-Test") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Downloadfowclxccdxn/uxwn.ddywww.easymessage.net\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
