(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\+[0-9]{2,}[0-9]{4,}[0-9]*)(x?[0-9]{1,})?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "x")) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}+") (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.* (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.range "0" "9"))))))
; User-Agent\x3A\s+\x7D\x7BPort\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Port:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
