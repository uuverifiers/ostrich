(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ref\x3D\u{25}user\x5Fid\s+X-Mailer\u{3a}SpyBuddyUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "ref=%user_id") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}SpyBuddyUser-Agent:\u{0a}"))))
; /^([A-Za-z]){1}([A-Za-z0-9-_.\:])+$/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_") (str.to_re ".") (str.to_re ":"))) (str.to_re "/\u{0a}")))))
; 62[0-9]{14,17}
(assert (str.in_re X (re.++ (str.to_re "62") ((_ re.loop 14 17) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; config\x2E180solutions\x2Ecom\dStable\s+Host\u{3a}\x7D\x7C
(assert (not (str.in_re X (re.++ (str.to_re "config.180solutions.com") (re.range "0" "9") (str.to_re "Stable") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:}|\u{0a}")))))
; protocolNetControl\x2EServerKEYLOGGERUser-Agent\x3A
(assert (str.in_re X (str.to_re "protocolNetControl.Server\u{13}KEYLOGGERUser-Agent:\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
