(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\(\?[gimxs]{1,5}\)/
(assert (str.in_re X (re.++ (str.to_re "/(?") ((_ re.loop 1 5) (re.union (str.to_re "g") (str.to_re "i") (str.to_re "m") (str.to_re "x") (str.to_re "s"))) (str.to_re ")/\u{0a}"))))
; pjpoptwql\u{2f}rlnjsportsHost\x3ASubject\u{3a}YAHOOdestroyed\u{21}
(assert (not (str.in_re X (str.to_re "pjpoptwql/rlnjsportsHost:Subject:YAHOOdestroyed!\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
