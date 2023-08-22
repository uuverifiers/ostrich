(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Authorization\u{3a}\d+lnzzlnbk\u{2f}pkrm\.fin
(assert (not (str.in_re X (re.++ (str.to_re "Authorization:") (re.+ (re.range "0" "9")) (str.to_re "lnzzlnbk/pkrm.fin\u{0a}")))))
; ^(100([\.\,]0{1,2})?)|(\d{1,2}[\.\,]\d{1,2})|(\d{0,2})$
(assert (str.in_re X (re.union (re.++ (str.to_re "100") (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 2) (str.to_re "0"))))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
