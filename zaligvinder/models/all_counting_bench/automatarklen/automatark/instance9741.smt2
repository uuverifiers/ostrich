(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]{2}[0-9]{6}[A-DFM]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "D") (str.to_re "F") (str.to_re "M"))) (str.to_re "\u{0a}")))))
; Toolbar\s+pjpoptwql\u{2f}rlnjSubject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "pjpoptwql/rlnjSubject:\u{0a}")))))
; ^[a-z0-9,!#\$%&'\*\+/=\?\^_`\{\|}~-]+(\.[a-z0-9,!#\$%&'\*\+/=\?\^_`\{\|}~-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,})$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re ",") (str.to_re "!") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "/") (str.to_re "=") (str.to_re "?") (str.to_re "^") (str.to_re "_") (str.to_re "`") (str.to_re "{") (str.to_re "|") (str.to_re "}") (str.to_re "~") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re ",") (str.to_re "!") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "/") (str.to_re "=") (str.to_re "?") (str.to_re "^") (str.to_re "_") (str.to_re "`") (str.to_re "{") (str.to_re "|") (str.to_re "}") (str.to_re "~") (str.to_re "-"))))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re ".\u{0a}") ((_ re.loop 2 2) (re.range "a" "z")) (re.* (re.range "a" "z")))))
; Cookie\u{3a}.*Host\x3A.*ldap\x3A\x2F\x2F
(assert (str.in_re X (re.++ (str.to_re "Cookie:") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "ldap://\u{0a}"))))
; ^([1-9]|0[1-9]|1[0-2]):([0-5][0-9])$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":\u{0a}") (re.range "0" "5") (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
