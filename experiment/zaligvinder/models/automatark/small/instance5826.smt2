(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([A-Z]{1,2}[0-9]{1,2})|([A-Z]{1,2}[0-9][A-Z]))\s?([0-9][A-Z]{2})$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "0" "9") (re.range "A" "Z"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}") (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")))))
; ^(0[1-9]|1[0-2])\/((0[1-9]|2\d)|3[0-1])\/(19\d\d|200[0-3])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "2") (re.range "0" "9"))) (str.to_re "/") (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "200") (re.range "0" "3"))) (str.to_re "\u{0a}")))))
; ^\-?\(?([0-9]{0,3}(\,?[0-9]{3})*(\.?[0-9]*))\)?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "(")) (re.opt (str.to_re ")")) (str.to_re "\u{0a}") ((_ re.loop 0 3) (re.range "0" "9")) (re.* (re.++ (re.opt (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")))))
; .*(\.[Jj][Pp][Gg]|\.[Gg][Ii][Ff]|\.[Jj][Pp][Ee][Gg]|\.[Pp][Nn][Gg])
(assert (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}.") (re.union (re.++ (re.union (str.to_re "J") (str.to_re "j")) (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "G") (str.to_re "g"))) (re.++ (re.union (str.to_re "G") (str.to_re "g")) (re.union (str.to_re "I") (str.to_re "i")) (re.union (str.to_re "F") (str.to_re "f"))) (re.++ (re.union (str.to_re "J") (str.to_re "j")) (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "E") (str.to_re "e")) (re.union (str.to_re "G") (str.to_re "g"))) (re.++ (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "N") (str.to_re "n")) (re.union (str.to_re "G") (str.to_re "g")))))))
(check-sat)
