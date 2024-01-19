(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([\+][0-9]{1,3}[\.][0-9]{1,12})([x]?[0-9]{1,4}?)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}+") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 12) (re.range "0" "9")) (re.opt (str.to_re "x")) ((_ re.loop 1 4) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
