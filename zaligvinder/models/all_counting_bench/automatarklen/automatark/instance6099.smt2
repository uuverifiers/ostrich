(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9][0-9]{0,6}(|.[0-9]{1,2}|,[0-9]{1,2})?
(assert (not (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 0 6) (re.range "0" "9")) (re.opt (re.union (re.++ re.allchar ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re ",") ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
