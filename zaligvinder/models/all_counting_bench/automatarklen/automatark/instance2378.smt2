(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (private|public|protected)\s\w(.)*\((.)*\)[^;]
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* re.allchar) (str.to_re "(") (re.* re.allchar) (str.to_re ")") (re.comp (str.to_re ";")) (str.to_re "\u{0a}p") (re.union (str.to_re "rivate") (str.to_re "ublic") (str.to_re "rotected")))))
; ^((0[1-9])|(1[0-2]))\/((0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))\/(\d{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
