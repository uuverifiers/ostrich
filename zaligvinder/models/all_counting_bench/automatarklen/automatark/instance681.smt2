(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]{1}[0-9]{3}[,]?)*([1-9]{1}[0-9]{3})$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")))))
; ookflolfctm\u{2f}nmot\.fmu
(assert (not (str.in_re X (str.to_re "ookflolfctm/nmot.fmu\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
