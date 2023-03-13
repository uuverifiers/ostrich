(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}wax([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.wax") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^(4915[0-1]|491[0-4]\d|490\d\d|4[0-8]\d{3}|[1-3]\d{4}|[2-9]\d{3}|1[1-9]\d{2}|10[3-9]\d|102[4-9])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "4915") (re.range "0" "1")) (re.++ (str.to_re "491") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "490") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "4") (re.range "0" "8") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "3") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "10") (re.range "3" "9") (re.range "0" "9")) (re.++ (str.to_re "102") (re.range "4" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
