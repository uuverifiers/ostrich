(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Referer\x3ATencentTraveler
(assert (str.in_re X (str.to_re "Referer:TencentTraveler\u{0a}")))
; ^([1-9]{1}[\d]{0,2}(\,[\d]{3})*(\.[\d]{0,2})?|[1-9]{1}[\d]{0,}(\.[\d]{0,2})?|0(\.[\d]{0,2})?|(\.[\d]{1,2})?)$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; ^[a-zA-Z0-9_\s-]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
