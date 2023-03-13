(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}xap/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xap/i\u{0a}")))))
; /filename=[^\n]*\u{2e}avi/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".avi/i\u{0a}")))))
; ^\W{0,5}[Rr]e:\W[a-zA-Z0-9]{1,10},\W[a-z]{1,10}\W[a-z]{1,10}\W[a-z]{1,10}
(assert (str.in_re X (re.++ ((_ re.loop 0 5) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "R") (str.to_re "r")) (str.to_re "e:") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ",") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (str.to_re "\u{0a}"))))
; ^[0-9]{1}$|^[1-6]{1}[0-3]{1}$|^64$|\-[1-9]{1}$|^\-[1-6]{1}[0-3]{1}$|^\-64$
(assert (str.in_re X (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 1 1) (re.range "0" "3"))) (str.to_re "64") (re.++ (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 1 1) (re.range "0" "3"))) (str.to_re "-64\u{0a}"))))
; ^([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$
(assert (str.in_re X (re.++ (re.* (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "+") (str.to_re "&")))) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "."))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
(check-sat)
