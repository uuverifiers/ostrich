(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [\w!#$%&&apos;*+./=?`{|}~^-]+@[\d.A-Za-z-]+
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "!") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "&") (str.to_re "a") (str.to_re "p") (str.to_re "o") (str.to_re "s") (str.to_re ";") (str.to_re "*") (str.to_re "+") (str.to_re ".") (str.to_re "/") (str.to_re "=") (str.to_re "?") (str.to_re "`") (str.to_re "{") (str.to_re "|") (str.to_re "}") (str.to_re "~") (str.to_re "^") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (str.to_re ".") (re.range "A" "Z") (re.range "a" "z") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; /\x3F[0-9a-z]{32}D/U
(assert (str.in_re X (re.++ (str.to_re "/?") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "D/U\u{0a}"))))
; ^[a-zA-Z]\:\\.*|^\\\\.*
(assert (not (str.in_re X (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":\u{5c}") (re.* re.allchar)) (re.++ (str.to_re "\u{5c}\u{5c}") (re.* re.allchar) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
