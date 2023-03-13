(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z ';-]+)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re " ") (str.to_re "'") (str.to_re ";") (str.to_re "-"))) (str.to_re "\u{0a}")))))
; /^allhttp\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/allhttp|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
; (1[8,9]|20)[0-9]{2}
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "8") (str.to_re ",") (str.to_re "9"))) (str.to_re "20")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (\d{1,2}(\:|\s)\d{1,2}(\:|\s)\d{1,2}\s*(AM|PM|A|P))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re ":") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re ":") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 1 2) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "AM") (str.to_re "PM") (str.to_re "A") (str.to_re "P"))))))
(check-sat)
