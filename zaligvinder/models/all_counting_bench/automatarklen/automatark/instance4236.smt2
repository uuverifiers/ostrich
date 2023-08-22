(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((192\.168\.0\.)(1[7-9]|2[0-9]|3[0-2]))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}192.168.0.") (re.union (re.++ (str.to_re "1") (re.range "7" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "2"))))))
; ^([a-zA-Z0-9!@#$%^&*()-_=+;:'"|~`<>?/{}]{1,5})$
(assert (str.in_re X (re.++ ((_ re.loop 1 5) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "*") (str.to_re "(") (re.range ")" "_") (str.to_re "=") (str.to_re "+") (str.to_re ";") (str.to_re ":") (str.to_re "'") (str.to_re "\u{22}") (str.to_re "|") (str.to_re "~") (str.to_re "`") (str.to_re "<") (str.to_re ">") (str.to_re "?") (str.to_re "/") (str.to_re "{") (str.to_re "}"))) (str.to_re "\u{0a}"))))
; sidesearch\.dropspam\.com\s+Strip-Player\s+
(assert (str.in_re X (re.++ (str.to_re "sidesearch.dropspam.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Strip-Player\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ^([A-Z]|[a-z]|[0-9])([A-Z]|[a-z]|[0-9]|([A-Z]|[a-z]|[0-9]|(%|&|'|\+|\-|@|_|\.|\ )[^%&'\+\-@_\.\ ]|\.$|([%&'\+\-@_\.]\ [^\ ]|\ [%&'\+\-@_\.][^%&'\+\-@_\.])))+$
(assert (not (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (re.++ (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".") (str.to_re " ")) (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".") (str.to_re " "))) (str.to_re ".") (re.++ (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".")) (str.to_re " ") (re.comp (str.to_re " "))) (re.++ (str.to_re " ") (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".")) (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re "."))))) (str.to_re "\u{0a}")))))
; BY\s+\u{22}The\dUser-Agent\x3AserverUSER-Attached
(assert (not (str.in_re X (re.++ (str.to_re "BY") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}The") (re.range "0" "9") (str.to_re "User-Agent:serverUSER-Attached\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
