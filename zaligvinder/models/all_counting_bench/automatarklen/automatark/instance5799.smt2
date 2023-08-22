(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^\u{20}-\u{7e}\u{0d}\u{0a}]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}")))))
; thesearchresltLoggerHost\x3ABetaHWAEHost\x3Ais
(assert (not (str.in_re X (str.to_re "thesearchresltLoggerHost:BetaHWAEHost:is\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
