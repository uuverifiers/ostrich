(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]|0[1-9]|1[0-2]):([0-5][0-9])$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":\u{0a}") (re.range "0" "5") (re.range "0" "9")))))
; ^((0{1})?([0-3]{0,1}))(\.[0-9]{0,2})?$|^(4)(\.[0]{1,2})?$|^((0{1})?([0-4]{0,1}))(\.)?$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (re.opt ((_ re.loop 1 1) (str.to_re "0"))) (re.opt (re.range "0" "3"))) (re.++ (str.to_re "4") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0"))))) (re.++ (re.opt (str.to_re ".")) (str.to_re "\u{0a}") (re.opt ((_ re.loop 1 1) (str.to_re "0"))) (re.opt (re.range "0" "4")))))))
; (\w+([-+.']\w+)*@(gmail.com))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re "+") (str.to_re ".") (str.to_re "'")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "@gmail") re.allchar (str.to_re "com"))))
; ^(((\+{1})|(0{2}))98|(0{1}))9[1-9]{1}\d{8}\Z$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union ((_ re.loop 1 1) (str.to_re "+")) ((_ re.loop 2 2) (str.to_re "0"))) (str.to_re "98")) ((_ re.loop 1 1) (str.to_re "0"))) (str.to_re "9") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
