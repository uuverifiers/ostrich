(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d){7,8}$
(assert (str.in_re X (re.++ ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(\$)?((\d+)|(\d{1,3})(\,\d{3})*)(\.\d{2,})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")) (re.* (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /skillName\x3D\x7B\u{28}\u{23}/Ui
(assert (not (str.in_re X (str.to_re "/skillName={(#/Ui\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
