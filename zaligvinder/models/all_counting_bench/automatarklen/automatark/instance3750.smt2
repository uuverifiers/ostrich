(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(4915[0-1]|491[0-4]\d|490\d\d|4[0-8]\d{3}|[1-3]\d{4}|[1-9]\d{0,3}|0)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "4915") (re.range "0" "1")) (re.++ (str.to_re "491") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "490") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "4") (re.range "0" "8") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "3") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9"))) (str.to_re "0")) (str.to_re "\u{0a}")))))
; (^0.*[1-9]*)|(^860+)|(^8613)|(\D)|([0-9])
(assert (not (str.in_re X (re.union (re.++ (str.to_re "0") (re.* re.allchar) (re.* (re.range "1" "9"))) (re.++ (str.to_re "86") (re.+ (str.to_re "0"))) (str.to_re "8613") (re.comp (re.range "0" "9")) (re.++ (re.range "0" "9") (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
