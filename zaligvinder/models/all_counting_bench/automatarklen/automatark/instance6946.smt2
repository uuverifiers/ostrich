(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{40}\u{40}\u{40}([0-9A-Z]{2}\x2D){5}[0-9A-Z]{2}/iP
(assert (not (str.in_re X (re.++ (str.to_re "/@@@") ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (str.to_re "-"))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (str.to_re "/iP\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
