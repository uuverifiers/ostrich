(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\w+([-+.']\w+)*@(gmail.com))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re "+") (str.to_re ".") (str.to_re "'")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "@gmail") re.allchar (str.to_re "com")))))
; (^(((\d)|(\d\d)|(\d\d\d))(\xA0|\u{20}))*((\d)|(\d\d)|(\d\d\d))([,.]\d*)?$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.++ (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (re.union (str.to_re "\u{a0}") (str.to_re " ")))) (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (re.opt (re.++ (re.union (str.to_re ",") (str.to_re ".")) (re.* (re.range "0" "9")))))))
; ^(\d{1,4}?[.]{0,1}?\d{0,3}?)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 4) (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 0 3) (re.range "0" "9"))))))
; ^-?([1-8]?[1-9]|[1-9]0)\.{1}\d{1,6}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (re.range "1" "8")) (re.range "1" "9")) (re.++ (re.range "1" "9") (str.to_re "0"))) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ((^(10|12|0?[13578])(3[01]|[12][0-9]|0?[1-9])((1[8-9]\d{2})|([2-9]\d{3}))$)|(^(11|0?[469])(30|[12][0-9]|0?[1-9])((1[8-9]\d{2})|([2-9]\d{3}))$)|(^(0?2)(2[0-8]|1[0-9]|0?[1-9])((1[8-9]\d{2})|([2-9]\d{3}))$)|(^(0?2)(29)([2468][048]00)$)|(^(0?2)(29)([3579][26]00)$)|(^(0?2)(29)([1][89][0][48])$)|(^(0?2)(29)([2-9][0-9][0][48])$)|(^(0?2)(29)([1][89][2468][048])$)|(^(0?2)(29)([2-9][0-9][2468][048])$)|(^(0?2)(29)([1][89][13579][26])$)|(^(0?2)(29)([2-9][0-9][13579][26])$))
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "10") (str.to_re "12") (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8")))) (re.union (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (re.++ (str.to_re "1") (re.range "8" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.union (str.to_re "11") (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9")))) (re.union (str.to_re "30") (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (re.++ (str.to_re "1") (re.range "8" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.union (re.++ (str.to_re "2") (re.range "0" "8")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (re.++ (str.to_re "1") (re.range "8" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (str.to_re "29") (re.opt (str.to_re "0")) (str.to_re "2") (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8")) (str.to_re "00")) (re.++ (str.to_re "29") (re.opt (str.to_re "0")) (str.to_re "2") (re.union (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6")) (str.to_re "00")) (re.++ (str.to_re "29") (re.opt (str.to_re "0")) (str.to_re "21") (re.union (str.to_re "8") (str.to_re "9")) (str.to_re "0") (re.union (str.to_re "4") (str.to_re "8"))) (re.++ (str.to_re "29") (re.opt (str.to_re "0")) (str.to_re "2") (re.range "2" "9") (re.range "0" "9") (str.to_re "0") (re.union (str.to_re "4") (str.to_re "8"))) (re.++ (str.to_re "29") (re.opt (str.to_re "0")) (str.to_re "21") (re.union (str.to_re "8") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (str.to_re "29") (re.opt (str.to_re "0")) (str.to_re "2") (re.range "2" "9") (re.range "0" "9") (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (str.to_re "29") (re.opt (str.to_re "0")) (str.to_re "21") (re.union (str.to_re "8") (str.to_re "9")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6"))) (re.++ (str.to_re "29") (re.opt (str.to_re "0")) (str.to_re "2") (re.range "2" "9") (re.range "0" "9") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6")))) (str.to_re "\u{0a}"))))
(check-sat)