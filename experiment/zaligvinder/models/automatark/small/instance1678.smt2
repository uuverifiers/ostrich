(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; wowokayoffers\x2Ebullseye-network\x2EcomRTB\x0D\x0A\x0D\x0AAttached
(assert (not (str.in_re X (str.to_re "wowokayoffers.bullseye-network.comRTB\u{0d}\u{0a}\u{0d}\u{0a}Attached\u{0a}"))))
; <a[a-zA-Z0-9 ="'.?_/]*(href\s*=\s*){1}[a-zA-Z0-9 ="'.?_/]*\s*((/>)|(>[a-zA-Z0-9 ="'<>.?_/]*</a>))
(assert (not (str.in_re X (re.++ (str.to_re "<a") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "=") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ".") (str.to_re "?") (str.to_re "_") (str.to_re "/"))) ((_ re.loop 1 1) (re.++ (str.to_re "href") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "=") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ".") (str.to_re "?") (str.to_re "_") (str.to_re "/"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "/>") (re.++ (str.to_re ">") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "=") (str.to_re "\u{22}") (str.to_re "'") (str.to_re "<") (str.to_re ">") (str.to_re ".") (str.to_re "?") (str.to_re "_") (str.to_re "/"))) (str.to_re "</a>"))) (str.to_re "\u{0a}")))))
; /\u{2e}crx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.crx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /\u{b6}\u{b6}\u{ff}\u{ff}\u{ff}\u{ff}$/
(assert (str.in_re X (str.to_re "/\u{b6}\u{b6}\u{ff}\u{ff}\u{ff}\u{ff}/\u{0a}")))
(check-sat)
