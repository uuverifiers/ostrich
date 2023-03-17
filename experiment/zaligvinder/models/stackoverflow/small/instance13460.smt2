;test regex "JOB:Level\\d+_([A-Z0-9_]{1,9})_(\\d+|%I)_\\w+_\\d+_\\d+"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "J") (re.++ (str.to_re "O") (re.++ (str.to_re "B") (re.++ (str.to_re ":") (re.++ (str.to_re "L") (re.++ (str.to_re "e") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 1 9) (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.++ (str.to_re "_") (re.++ (re.union (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))) (re.++ (str.to_re "%") (str.to_re "I"))) (re.++ (str.to_re "_") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "w")) (re.++ (str.to_re "_") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (re.++ (str.to_re "_") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (str.to_re "\u{22}"))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)