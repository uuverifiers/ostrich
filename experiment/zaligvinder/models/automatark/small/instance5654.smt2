(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /stat2\.php\?w=\d+\u{26}i=[0-9a-f]{32}\u{26}a=\d+/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/stat2.php?w=") (re.+ (re.range "0" "9")) (str.to_re "&i=") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "&a=") (re.+ (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; ^((0[1-9]|[12][0-9]|3[01])([/])(0[13578]|[1][02])([/])(19[0-9][0-9]|20[0-9][0-9]))|((0[1-9]|[12][0-9]|30)([/])(0[469]|11)([/])(19[0-9][0-9]|20[0-9][0-9]))|((0[1-9]|[1][0-9]|[2][0-8])([/])(02)([/])(19[0-9][0-9]|20[0-9][0-9]))|((29)([/])(02)([/])(190[48]|19[13579][26]|19[2468][048]|20[02468][048]|20[13579][26]))$
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "/") (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "20") (re.range "0" "9") (re.range "0" "9")))) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (str.to_re "30")) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (str.to_re "/") (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "20") (re.range "0" "9") (re.range "0" "9")))) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "8"))) (str.to_re "/02/") (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "20") (re.range "0" "9") (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}29/02/") (re.union (re.++ (str.to_re "190") (re.union (str.to_re "4") (str.to_re "8"))) (re.++ (str.to_re "19") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6"))) (re.++ (str.to_re "19") (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (str.to_re "20") (re.union (str.to_re "0") (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (str.to_re "20") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6"))))))))
(check-sat)