(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[0-9a-fA-F]{8}[a-z]{6}.php/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) ((_ re.loop 6 6) (re.range "a" "z")) re.allchar (str.to_re "php/\u{0a}")))))
; ^(([1-9])|(0[1-9])|(1[0-2]))\/((0[1-9])|([1-31]))\/((\d{2})|(\d{4}))$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.range "1" "3") (str.to_re "1")) (str.to_re "/") (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; Server\u{00}\s+SbAts\s+versionetbuviaebe\u{2f}eqv\.bvv
(assert (str.in_re X (re.++ (str.to_re "Server\u{00}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SbAts") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "versionetbuviaebe/eqv.bvv\u{0a}"))))
; ^([a-zA-Z0-9!@#$%^&*()-_=+;:'"|~`<>?/{}]{1,5})$
(assert (str.in_re X (re.++ ((_ re.loop 1 5) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "*") (str.to_re "(") (re.range ")" "_") (str.to_re "=") (str.to_re "+") (str.to_re ";") (str.to_re ":") (str.to_re "'") (str.to_re "\u{22}") (str.to_re "|") (str.to_re "~") (str.to_re "`") (str.to_re "<") (str.to_re ">") (str.to_re "?") (str.to_re "/") (str.to_re "{") (str.to_re "}"))) (str.to_re "\u{0a}"))))
(check-sat)
