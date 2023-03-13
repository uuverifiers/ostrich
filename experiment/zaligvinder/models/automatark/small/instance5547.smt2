(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /User\u{2d}Agent\u{3a}\u{20}[A-F\d]{32}\r\n/H
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent: ") ((_ re.loop 32 32) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "\u{0d}\u{0a}/H\u{0a}")))))
(check-sat)
