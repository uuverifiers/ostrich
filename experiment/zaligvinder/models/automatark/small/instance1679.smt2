(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^User-Agent\u{3a}\u{20}[A-Z]{9}\u{0d}\u{0a}/Hm
(assert (str.in_re X (re.++ (str.to_re "/User-Agent: ") ((_ re.loop 9 9) (re.range "A" "Z")) (str.to_re "\u{0d}\u{0a}/Hm\u{0a}"))))
(check-sat)
