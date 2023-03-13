(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /User-Agent\u{3a}\u{20}[^\u{0d}\u{0a}]*?\u{3b}U\u{3a}[^\u{0d}\u{0a}]{1,68}\u{3b}rv\u{3a}/H
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent: ") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ";U:") ((_ re.loop 1 68) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ";rv:/H\u{0a}")))))
(check-sat)
