(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^full\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/full|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
; X-FILTERED-BY-GHOST\u{3a}\d+yxegtd\u{2f}efcwgHost\x3ATPSystem
(assert (not (str.in_re X (re.++ (str.to_re "X-FILTERED-BY-GHOST:") (re.+ (re.range "0" "9")) (str.to_re "yxegtd/efcwgHost:TPSystem\u{0a}")))))
(check-sat)
