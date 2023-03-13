(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\u{3a}SpywareSpyBuddy
(assert (not (str.in_re X (str.to_re "Subject:SpywareSpyBuddy\u{0a}"))))
; /^[a-z]{5}\d=_\d_/C
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 5 5) (re.range "a" "z")) (re.range "0" "9") (str.to_re "=_") (re.range "0" "9") (str.to_re "_/C\u{0a}")))))
; User-Agent\x3A\s+GET\d+\x2Fcommunicatortb
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "GET") (re.+ (re.range "0" "9")) (str.to_re "/communicatortb\u{0a}"))))
; pgwtjgxwthx\u{2f}byb\.xkyLOGurl=enews\x2Eearthlink\x2Enet
(assert (not (str.in_re X (str.to_re "pgwtjgxwthx/byb.xkyLOGurl=enews.earthlink.net\u{0a}"))))
(check-sat)
