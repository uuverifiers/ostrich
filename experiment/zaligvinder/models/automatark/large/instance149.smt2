(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(|(0\d)|(1[0-2])):(([0-5]\d)):(([0-5]\d))\s([AP]M)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "::") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9") (re.union (str.to_re "A") (str.to_re "P")) (str.to_re "M")))))
; User-Agent\u{3a}Host\x3AHost\x3ASpyBuddy
(assert (str.in_re X (str.to_re "User-Agent:Host:Host:SpyBuddy\u{0a}")))
; /\/[a-f0-9]{32}\/\d{10}\/[a-f0-9]{32}\/\d{10}\.tpl$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re ".tpl/U\u{0a}"))))
(check-sat)
