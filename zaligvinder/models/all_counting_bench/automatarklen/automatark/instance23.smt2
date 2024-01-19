(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9a-fA-F]{1,2})(\s[0-9a-fA-F]{1,2})*$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.* (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))) (str.to_re "\u{0a}"))))
; /ID3\u{03}\u{00}.{5}([TW][A-Z]{3}|COMM)/smi
(assert (not (str.in_re X (re.++ (str.to_re "/ID3\u{03}\u{00}") ((_ re.loop 5 5) re.allchar) (re.union (re.++ (re.union (str.to_re "T") (str.to_re "W")) ((_ re.loop 3 3) (re.range "A" "Z"))) (str.to_re "COMM")) (str.to_re "/smi\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
