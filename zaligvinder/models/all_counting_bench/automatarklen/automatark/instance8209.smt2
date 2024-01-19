(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0[1-6]{1}(([0-9]{2}){4})|((\s[0-9]{2}){4})|((-[0-9]{2}){4})$
(assert (str.in_re X (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 4 4) ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 4 4) (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ ((_ re.loop 4 4) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; DesktopHost\x3Aact=Microsoft
(assert (str.in_re X (str.to_re "DesktopHost:act=Microsoft\u{0a}")))
; \b\w+\b
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; ^(([1-9]\d{0,2}(\,\d{3})*|([1-9]\d*))(\.\d{2})?)|([0]\.(([0][1-9])|([1-9]\d)))$
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "\u{0a}0.") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))))))))
(assert (> (str.len X) 10))
(check-sat)
