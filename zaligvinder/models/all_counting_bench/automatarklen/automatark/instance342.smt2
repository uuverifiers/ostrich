(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\()?(787|939)(\)|-)?([0-9]{3})(-)?([0-9]{4}|[0-9]{4})$
(assert (str.in_re X (re.++ (re.opt (str.to_re "(")) (re.union (str.to_re "787") (str.to_re "939")) (re.opt (re.union (str.to_re ")") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
