(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([(][1-9]{2}[)] )?[0-9]{4}[-]?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "(") ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re ") "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
