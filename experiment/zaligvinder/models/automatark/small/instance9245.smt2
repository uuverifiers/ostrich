(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (http://)?(www\.)?(youtube|yimg|youtu)\.([A-Za-z]{2,4}|[A-Za-z]{2}\.[A-Za-z]{2})/(watch\?v=)?[A-Za-z0-9\-_]{6,12}(&[A-Za-z0-9\-_]{1,}=[A-Za-z0-9\-_]{1,})*
(assert (str.in_re X (re.++ (re.opt (str.to_re "http://")) (re.opt (str.to_re "www.")) (str.to_re ".") (re.union ((_ re.loop 2 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))))) (str.to_re "/") (re.opt (str.to_re "watch?v=")) ((_ re.loop 6 12) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))) (re.* (re.++ (str.to_re "&") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))) (str.to_re "=") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))))) (str.to_re "\u{0a}y") (re.union (str.to_re "outube") (str.to_re "img") (str.to_re "outu")))))
; ^\d+(\.\d{2})?$
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
