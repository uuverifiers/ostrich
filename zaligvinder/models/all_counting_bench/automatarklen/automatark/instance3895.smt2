(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(\u{19}\u{00}|\u{00}\x5C)\u{00}n\u{00}w\u{00}d\u{00}b\u{00}l\u{00}i\u{00}b\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{19}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}n\u{00}w\u{00}d\u{00}b\u{00}l\u{00}i\u{00}b\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}")))))
; FTP\s+\x7D\x7BPort\x3A\s+Host\x3A
(assert (str.in_re X (re.++ (str.to_re "FTP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Port:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; ^\d{4,4}[A-Z0-9]$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.range "A" "Z") (re.range "0" "9")) (str.to_re "\u{0a}"))))
; [a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-4") ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") (re.union (str.to_re "8") (str.to_re "9") (str.to_re "a") (str.to_re "b")) ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
