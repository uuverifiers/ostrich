(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+][0-9]\d{2}-\d{3}-\d{4}$
(assert (str.in_re X (re.++ (str.to_re "+") (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(\$|)([1-9]\d{0,2}(\,\d{3})*|([1-9]\d*))(\.\d{2})?$
(assert (str.in_re X (re.++ (str.to_re "$") (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\x3Fp\x3D[0-9]{1,10}\u{26}d\x3D/U
(assert (not (str.in_re X (re.++ (str.to_re "/?p=") ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re "&d=/U\u{0a}")))))
(check-sat)
