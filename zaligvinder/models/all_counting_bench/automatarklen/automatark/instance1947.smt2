(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{2,6}-\d{2}-\d$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}")))))
; /^\/[a-f0-9]{32}\.php\?q=[a-f0-9]{32}$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".php?q=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; ProPOWRSTRPquick\x2Eqsrch\x2EcomReferer\x3A
(assert (str.in_re X (str.to_re "ProPOWRSTRPquick.qsrch.comReferer:\u{0a}")))
; thesearchresltLoggerHost\x3ABetaHWAEHost\x3Ais
(assert (str.in_re X (str.to_re "thesearchresltLoggerHost:BetaHWAEHost:is\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
