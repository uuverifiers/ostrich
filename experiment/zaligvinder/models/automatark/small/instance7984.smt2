(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; myInstance\.myMethod(.*)\(.*myParam.*\)
(assert (str.in_re X (re.++ (str.to_re "myInstance.myMethod") (re.* re.allchar) (str.to_re "(") (re.* re.allchar) (str.to_re "myParam") (re.* re.allchar) (str.to_re ")\u{0a}"))))
; (^0[87][23467]((\d{7})|( |-)((\d{3}))( |-)(\d{4})|( |-)(\d{7})))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}0") (re.union (str.to_re "8") (str.to_re "7")) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7")) (re.union ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")))))))
; ^[A-Za-z]:\\([^"*/:?|<>\\.\u{00}-\u{20}]([^"*/:?|<>\\\u{00}-\x1F]*[^"*/:?|<>\\.\u{00}-\u{20}])?\\)*$
(assert (not (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (str.to_re ":\u{5c}") (re.* (re.++ (re.union (str.to_re "\u{22}") (str.to_re "*") (str.to_re "/") (str.to_re ":") (str.to_re "?") (str.to_re "|") (str.to_re "<") (str.to_re ">") (str.to_re "\u{5c}") (str.to_re ".") (re.range "\u{00}" " ")) (re.opt (re.++ (re.* (re.union (str.to_re "\u{22}") (str.to_re "*") (str.to_re "/") (str.to_re ":") (str.to_re "?") (str.to_re "|") (str.to_re "<") (str.to_re ">") (str.to_re "\u{5c}") (re.range "\u{00}" "\u{1f}"))) (re.union (str.to_re "\u{22}") (str.to_re "*") (str.to_re "/") (str.to_re ":") (str.to_re "?") (str.to_re "|") (str.to_re "<") (str.to_re ">") (str.to_re "\u{5c}") (str.to_re ".") (re.range "\u{00}" " ")))) (str.to_re "\u{5c}"))) (str.to_re "\u{0a}")))))
; ^(([0]{0,1})([1-9]{1})([0-9]{2})){1}([\ ]{0,1})((([0-9]{3})([\ ]{0,1})([0-9]{3}))|(([0-9]{2})([\ ]{0,1})([0-9]{2})([\ ]{0,1})([0-9]{2})))$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ (re.opt (str.to_re "0")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.opt (str.to_re " ")) (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; adblock\x2Elinkz\x2Ecomwww\.iggsey\.comHost\x3A
(assert (not (str.in_re X (str.to_re "adblock.linkz.comwww.iggsey.comHost:\u{0a}"))))
(check-sat)
