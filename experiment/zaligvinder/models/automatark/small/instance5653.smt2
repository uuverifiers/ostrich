(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^\u{20}-\u{7e}\u{0d}\u{0a}]{4}/P
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}"))))
; jsp\s+pjpoptwql\u{2f}rlnj[^\n\r]*Host\x3A
(assert (str.in_re X (re.++ (str.to_re "jsp") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "pjpoptwql/rlnj") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
(check-sat)
