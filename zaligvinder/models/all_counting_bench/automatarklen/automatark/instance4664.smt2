(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9]{1}$|^[1-4]{1}[0-9]{1}$|^50$
(assert (str.in_re X (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "4")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "50\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
