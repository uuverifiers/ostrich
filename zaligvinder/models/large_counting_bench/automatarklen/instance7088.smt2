(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[/]*([^/\\ \:\*\?"\<\>\|\.][^/\\\:\*\?\"\<\>\|]{0,63}/)*[^/\\ \:\*\?"\<\>\|\.][^/\\\:\*\?\"\<\>\|]{0,63}$
(assert (str.in_re X (re.++ (re.* (str.to_re "/")) (re.* (re.++ (re.union (str.to_re "/") (str.to_re "\u{5c}") (str.to_re " ") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|") (str.to_re ".")) ((_ re.loop 0 63) (re.union (str.to_re "/") (str.to_re "\u{5c}") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re "/"))) (re.union (str.to_re "/") (str.to_re "\u{5c}") (str.to_re " ") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|") (str.to_re ".")) ((_ re.loop 0 63) (re.union (str.to_re "/") (str.to_re "\u{5c}") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re "\u{0a}"))))
; /\u{2e}manifest([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.manifest") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; [^A-Za-z0-9 ]
(assert (not (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re " ")) (str.to_re "\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
