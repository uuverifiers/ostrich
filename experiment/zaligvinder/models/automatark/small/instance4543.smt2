(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [+]346[0-9]{8}
(assert (str.in_re X (re.++ (str.to_re "+346") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[-]?[0-9]*\.?[0-9]?[0-9]?[0-9]?[0-9]?
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
