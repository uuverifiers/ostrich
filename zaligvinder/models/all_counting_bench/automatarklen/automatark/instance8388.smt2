(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]+$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (^(352)[8-9](\d{11}$|\d{12}$))|(^(35)[3-8](\d{12}$|\d{13}$))
(assert (not (str.in_re X (re.union (re.++ (str.to_re "352") (re.range "8" "9") (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 12 12) (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}35") (re.range "3" "8") (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 13 13) (re.range "0" "9"))))))))
; (\w(\s)?)+
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "\u{0a}")))))
; /[1-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}/H
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "1" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/H\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
