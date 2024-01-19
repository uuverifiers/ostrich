(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[ .a-zA-Z0-9:-]{1,150}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 150) (re.union (str.to_re " ") (str.to_re ".") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ":") (str.to_re "-"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
