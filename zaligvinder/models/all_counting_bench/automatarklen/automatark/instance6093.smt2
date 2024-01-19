(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]\d{2}(\.\d){0,1}$
(assert (str.in_re X (re.++ (re.range "A" "Z") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
