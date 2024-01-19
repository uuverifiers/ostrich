(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\<(.*?)\>)(.*?)(\<\/(.*?)\>)
(assert (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}<") (re.* re.allchar) (str.to_re "></") (re.* re.allchar) (str.to_re ">"))))
; ^\d{1}(\.\d{3})-\d{3}(\.\d{1})$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}.") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
