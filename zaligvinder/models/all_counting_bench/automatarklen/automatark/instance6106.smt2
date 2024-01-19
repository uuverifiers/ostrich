(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}$
(assert (str.in_re X (re.++ ((_ re.loop 7 7) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (str.to_re ":"))) ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
