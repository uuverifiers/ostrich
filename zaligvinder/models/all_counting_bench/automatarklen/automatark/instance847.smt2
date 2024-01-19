(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([L|U]{1})([0-9]{5})([A-Za-z]{2})([0-9]{4})([A-Za-z]{3})([0-9]{6})$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "L") (str.to_re "|") (str.to_re "U"))) ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (UPDATE\s+)(\w+)\s+(SET)\s+([\w+\s*=\s*\w+,?\s*]+)\s+(WHERE.+)
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SET") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (str.to_re "+") (str.to_re "*") (str.to_re "=") (str.to_re ",") (str.to_re "?") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}UPDATE") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WHERE") (re.+ re.allchar)))))
(assert (> (str.len X) 10))
(check-sat)
