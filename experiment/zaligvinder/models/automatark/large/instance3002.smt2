(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9]{1}$|^[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}$|^9999$
(assert (not (str.in_re X (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "9999\u{0a}")))))
; ^(0[1-9]|1[0-2])\/((0[1-9]|2\d)|3[0-1])\/(19\d\d|200[0-3])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "2") (re.range "0" "9"))) (str.to_re "/") (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "200") (re.range "0" "3"))) (str.to_re "\u{0a}")))))
; /u=[\dA-Fa-f]{8}/smiU
(assert (str.in_re X (re.++ (str.to_re "/u=") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (str.to_re "/smiU\u{0a}"))))
; ^(\(\d{3}\)|\d{3})[\s.-]?\d{3}[\s.-]?\d{4}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[A-Z0-9a-z'&()/]{0,1}[A-Z0-9a-z'&()/]{0,1}(([A-Z0-9a-z'&()/_-])|(\\s)){0,47}[A-Z0-9a-z'&()/]{1}$
(assert (str.in_re X (re.++ (re.opt (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) (re.opt (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) ((_ re.loop 0 47) (re.union (str.to_re "\u{5c}s") (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/") (str.to_re "_") (str.to_re "-"))) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) (str.to_re "\u{0a}"))))
(check-sat)
