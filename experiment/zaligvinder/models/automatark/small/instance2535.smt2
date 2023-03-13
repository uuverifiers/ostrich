(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}vap/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vap/i\u{0a}")))))
; Agent\s+\x2Ftoolbar\x2Fico\x2F
(assert (not (str.in_re X (re.++ (str.to_re "Agent") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/ico/\u{0a}")))))
; User-Agent\x3A[^\n\r]*Host\x3A.*\x2Ftoolbar\x2FHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "/toolbar/Host:User-Agent:\u{0a}")))))
; <a[a-zA-Z0-9 ="'.?_/]*(href\s*=\s*){1}[a-zA-Z0-9 ="'.?_/]*\s*((/>)|(>[a-zA-Z0-9 ="'<>.?_/]*</a>))
(assert (not (str.in_re X (re.++ (str.to_re "<a") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "=") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ".") (str.to_re "?") (str.to_re "_") (str.to_re "/"))) ((_ re.loop 1 1) (re.++ (str.to_re "href") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "=") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ".") (str.to_re "?") (str.to_re "_") (str.to_re "/"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "/>") (re.++ (str.to_re ">") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "=") (str.to_re "\u{22}") (str.to_re "'") (str.to_re "<") (str.to_re ">") (str.to_re ".") (str.to_re "?") (str.to_re "_") (str.to_re "/"))) (str.to_re "</a>"))) (str.to_re "\u{0a}")))))
(check-sat)
