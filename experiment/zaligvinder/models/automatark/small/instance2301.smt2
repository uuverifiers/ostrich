(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; versionIDENTIFYstarted\x2EUser-Agent\x3A
(assert (str.in_re X (str.to_re "versionIDENTIFYstarted.User-Agent:\u{0a}")))
; Subject\u{3a}\s+BossUser-Agent\x3ASpediaUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "BossUser-Agent:SpediaUser-Agent:\u{0a}")))))
; ^\b\d{2,3}-*\d{7}\b$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.* (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
