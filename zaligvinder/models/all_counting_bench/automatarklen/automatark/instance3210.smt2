(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0[23489]{1}(\-)?[^0\D]{1}\d{6}$
(assert (not (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "8") (str.to_re "9"))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^([0-9a-fA-F]{4}|0)(\:([0-9a-fA-F]{4}|0)){7}$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "0")) ((_ re.loop 7 7) (re.++ (str.to_re ":") (re.union ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "0")))) (str.to_re "\u{0a}"))))
; /\/3001[0-9A-F]{262,304}/
(assert (not (str.in_re X (re.++ (str.to_re "//3001") ((_ re.loop 262 304) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/\u{0a}")))))
; ^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.++ (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}")))))
; ^[\w]{3}(p|P|c|C|h|H|f|F|a|A|t|T|b|B|l|L|j|J|g|G)[\w][\d]{4}[\w]$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "p") (str.to_re "P") (str.to_re "c") (str.to_re "C") (str.to_re "h") (str.to_re "H") (str.to_re "f") (str.to_re "F") (str.to_re "a") (str.to_re "A") (str.to_re "t") (str.to_re "T") (str.to_re "b") (str.to_re "B") (str.to_re "l") (str.to_re "L") (str.to_re "j") (str.to_re "J") (str.to_re "g") (str.to_re "G")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
