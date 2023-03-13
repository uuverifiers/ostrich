(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Keylogger[^\n\r]*dll\x3F\w+www2\u{2e}instantbuzz\u{2e}com\s+Online100013Agentsvr\x5E\x5EMerlinHost\x3AHost\x3Aport
(assert (str.in_re X (re.++ (str.to_re "Keylogger") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "dll?") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www2.instantbuzz.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Online100013Agentsvr^^Merlin\u{13}Host:Host:port\u{0a}"))))
; ^([a-zA-Z0-9!@#$%^&*()-_=+;:'"|~`<>?/{}]{1,5})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 5) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "*") (str.to_re "(") (re.range ")" "_") (str.to_re "=") (str.to_re "+") (str.to_re ";") (str.to_re ":") (str.to_re "'") (str.to_re "\u{22}") (str.to_re "|") (str.to_re "~") (str.to_re "`") (str.to_re "<") (str.to_re ">") (str.to_re "?") (str.to_re "/") (str.to_re "{") (str.to_re "}"))) (str.to_re "\u{0a}")))))
(check-sat)
