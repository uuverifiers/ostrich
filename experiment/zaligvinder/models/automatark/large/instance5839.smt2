(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/0[a-z]{0,13}[0-9]{0,12}[a-z][a-z0-9]{1,11}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//0") ((_ re.loop 0 13) (re.range "a" "z")) ((_ re.loop 0 12) (re.range "0" "9")) (re.range "a" "z") ((_ re.loop 1 11) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; fsbuff\s+User-Agent\x3Afrom\x3A
(assert (str.in_re X (re.++ (str.to_re "fsbuff") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:from:\u{0a}"))))
; /\/[a-f0-9]{32}\.jar/
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".jar/\u{0a}"))))
; dialup\u{5f}vpn\u{40}hermangroup\x2EorgUser-Agent\x3A
(assert (str.in_re X (str.to_re "dialup_vpn@hermangroup.orgUser-Agent:\u{0a}")))
; \x2Fsearchfast\x2F\s+Host\x3A\s+
(assert (not (str.in_re X (re.++ (str.to_re "/searchfast/") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
(check-sat)
