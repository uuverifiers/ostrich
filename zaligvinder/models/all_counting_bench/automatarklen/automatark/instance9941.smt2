(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{00}hide hide\u{22}\u{09}\u{22}([a-z0-9\u{5c}\u{2e}\u{3a}]+\u{2e}exe|sh)/
(assert (not (str.in_re X (re.++ (str.to_re "/\u{00}hide hide\u{22}\u{09}\u{22}") (re.union (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "\u{5c}") (str.to_re ".") (str.to_re ":"))) (str.to_re ".exe")) (str.to_re "sh")) (str.to_re "/\u{0a}")))))
; FTP\s+\x7D\x7BPort\x3A\s+Host\x3A
(assert (str.in_re X (re.++ (str.to_re "FTP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Port:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; ^(\d{5})$|^([a-zA-Z]\d[a-zA-Z]( )?\d[a-zA-Z]\d)$
(assert (str.in_re X (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.opt (str.to_re " ")) (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
