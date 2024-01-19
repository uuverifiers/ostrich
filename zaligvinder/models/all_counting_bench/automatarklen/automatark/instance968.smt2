(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ChildWebGuardian\d+Subject\x3A
(assert (str.in_re X (re.++ (str.to_re "ChildWebGuardian") (re.+ (re.range "0" "9")) (str.to_re "Subject:\u{0a}"))))
; ^\$[0-9]+(\.[0-9][0-9])?$
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; (^(5[0678])\d{11,18}$)|(^(6[^05])\d{11,18}$)|(^(601)[^1]\d{9,16}$)|(^(6011)\d{9,11}$)|(^(6011)\d{13,16}$)|(^(65)\d{11,13}$)|(^(65)\d{15,18}$)|(^(49030)[2-9](\d{10}$|\d{12,13}$))|(^(49033)[5-9](\d{10}$|\d{12,13}$))|(^(49110)[1-2](\d{10}$|\d{12,13}$))|(^(49117)[4-9](\d{10}$|\d{12,13}$))|(^(49118)[0-2](\d{10}$|\d{12,13}$))|(^(4936)(\d{12}$|\d{14,15}$))
(assert (str.in_re X (re.union (re.++ ((_ re.loop 11 18) (re.range "0" "9")) (str.to_re "5") (re.union (str.to_re "0") (str.to_re "6") (str.to_re "7") (str.to_re "8"))) (re.++ ((_ re.loop 11 18) (re.range "0" "9")) (str.to_re "6") (re.union (str.to_re "0") (str.to_re "5"))) (re.++ (str.to_re "601") (re.comp (str.to_re "1")) ((_ re.loop 9 16) (re.range "0" "9"))) (re.++ (str.to_re "6011") ((_ re.loop 9 11) (re.range "0" "9"))) (re.++ (str.to_re "6011") ((_ re.loop 13 16) (re.range "0" "9"))) (re.++ (str.to_re "65") ((_ re.loop 11 13) (re.range "0" "9"))) (re.++ (str.to_re "65") ((_ re.loop 15 18) (re.range "0" "9"))) (re.++ (str.to_re "49030") (re.range "2" "9") (re.union ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 12 13) (re.range "0" "9")))) (re.++ (str.to_re "49033") (re.range "5" "9") (re.union ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 12 13) (re.range "0" "9")))) (re.++ (str.to_re "49110") (re.range "1" "2") (re.union ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 12 13) (re.range "0" "9")))) (re.++ (str.to_re "49117") (re.range "4" "9") (re.union ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 12 13) (re.range "0" "9")))) (re.++ (str.to_re "49118") (re.range "0" "2") (re.union ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 12 13) (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}4936") (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 14 15) (re.range "0" "9")))))))
; 32e3432ew+
(assert (str.in_re X (re.++ (str.to_re "32e3432e") (re.+ (str.to_re "w")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
