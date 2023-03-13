(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [a-zA-Z]{3,}://[a-zA-Z0-9\.]+/*[a-zA-Z0-9/\\%_.]*\?*[a-zA-Z0-9/\\%_.=&]*
(assert (not (str.in_re X (re.++ (str.to_re "://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "."))) (re.* (str.to_re "/")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "%") (str.to_re "_") (str.to_re "."))) (re.* (str.to_re "?")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "%") (str.to_re "_") (str.to_re ".") (str.to_re "=") (str.to_re "&"))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z")))))))
; \x2APORT3\x2A\s+Warez.*X-Mailer\x3ASubject\x3AKEY=
(assert (not (str.in_re X (re.++ (str.to_re "*PORT3*") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Warez") (re.* re.allchar) (str.to_re "X-Mailer:\u{13}Subject:KEY=\u{0a}")))))
(check-sat)
