(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /exploit\/(Exploit(App)?|Loader)\.class/ims
(assert (str.in_re X (re.++ (str.to_re "/exploit/") (re.union (re.++ (str.to_re "Exploit") (re.opt (str.to_re "App"))) (str.to_re "Loader")) (str.to_re ".class/ims\u{0a}"))))
; ([.])([a-z,1-9]{3,4})(\/)
(assert (str.in_re X (re.++ (str.to_re ".") ((_ re.loop 3 4) (re.union (re.range "a" "z") (str.to_re ",") (re.range "1" "9"))) (str.to_re "/\u{0a}"))))
; /\/[a-zA-Z_-]+\.doc$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "-"))) (str.to_re ".doc/U\u{0a}")))))
; ^((\d{8})|(\d{10})|(\d{11})|(\d{6}-\d{5}))?$
(assert (str.in_re X (re.++ (re.opt (re.union ((_ re.loop 8 8) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 11 11) (re.range "0" "9")) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
