(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /update\/barcab\/.*?tn=.*id=.*version=/smi
(assert (not (str.in_re X (re.++ (str.to_re "/update/barcab/") (re.* re.allchar) (str.to_re "tn=") (re.* re.allchar) (str.to_re "id=") (re.* re.allchar) (str.to_re "version=/smi\u{0a}")))))
; ^(([1-9]{1}[0-9]{0,5}([.]{1}[0-9]{0,2})?)|(([0]{1}))([.]{1}[0-9]{0,2})?)$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 5) (re.range "0" "9")) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (str.to_re "0")) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 0 2) (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
(check-sat)
