(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; products\s+Host\x3A\s+User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "products") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}")))))
; ^([1-9]\d{3}|0[1-9]\d{2}|00[1-9]\d{1}|000[1-9]{1})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "0") (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "00") (re.range "1" "9") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "000") ((_ re.loop 1 1) (re.range "1" "9")))) (str.to_re "\u{0a}")))))
; ^(([0-9]|1[0-9]|2[0-4])(\.[0-9][0-9]?)?)$|([2][5](\.[0][0]?)?)$
(assert (str.in_re X (re.union (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4"))) (re.opt (re.++ (str.to_re ".") (re.range "0" "9") (re.opt (re.range "0" "9"))))) (re.++ (str.to_re "\u{0a}25") (re.opt (re.++ (str.to_re ".0") (re.opt (str.to_re "0"))))))))
; ^[2-9]{2}[0-9]{8}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "2" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
