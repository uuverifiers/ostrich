(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[a-z]\u{3d}[a-f\d]{80,140}$/Pi
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 80 140) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Pi\u{0a}"))))
; /^\d{2}[\-\/]\d{2}[\-\/]\d{4}$/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "/")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "/")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/\u{0a}"))))
; (^4\d{12}$)|(^4[0-8]\d{14}$)|(^(49)[^013]\d{13}$)|(^(49030)[0-1]\d{10}$)|(^(49033)[0-4]\d{10}$)|(^(49110)[^12]\d{10}$)|(^(49117)[0-3]\d{10}$)|(^(49118)[^0-2]\d{10}$)|(^(493)[^6]\d{12}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "4") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "4") (re.range "0" "8") ((_ re.loop 14 14) (re.range "0" "9"))) (re.++ (str.to_re "49") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "3")) ((_ re.loop 13 13) (re.range "0" "9"))) (re.++ (str.to_re "49030") (re.range "0" "1") ((_ re.loop 10 10) (re.range "0" "9"))) (re.++ (str.to_re "49033") (re.range "0" "4") ((_ re.loop 10 10) (re.range "0" "9"))) (re.++ (str.to_re "49110") (re.union (str.to_re "1") (str.to_re "2")) ((_ re.loop 10 10) (re.range "0" "9"))) (re.++ (str.to_re "49117") (re.range "0" "3") ((_ re.loop 10 10) (re.range "0" "9"))) (re.++ (str.to_re "49118") (re.range "0" "2") ((_ re.loop 10 10) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}493") (re.comp (str.to_re "6")) ((_ re.loop 12 12) (re.range "0" "9"))))))
; ^([0-9a-fA-F])*$
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}"))))
; /version\x3D[\u{22}\u{27}][^\u{22}\u{27}]{1024}/
(assert (str.in_re X (re.++ (str.to_re "/version=") (re.union (str.to_re "\u{22}") (str.to_re "'")) ((_ re.loop 1024 1024) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/\u{0a}"))))
(check-sat)
