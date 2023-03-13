(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\b(10|11|12|13|14|15|16|17|18|19)[0-9]\b)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.range "0" "9") (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))))))
; ^(([0]([2|3|4|5|6|8|9|7])))\d{7,8}$
(assert (not (str.in_re X (re.++ ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}0") (re.union (str.to_re "2") (str.to_re "|") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "8") (str.to_re "9") (str.to_re "7"))))))
; User-Agent\x3A\w+data2\.activshopper\.comdll\x3F
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "data2.activshopper.comdll?\u{0a}"))))
(check-sat)
