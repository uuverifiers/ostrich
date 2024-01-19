(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[/]*([^/\\ \:\*\?"\<\>\|\.][^/\\\:\*\?\"\<\>\|]{0,63}/)*[^/\\ \:\*\?"\<\>\|\.][^/\\\:\*\?\"\<\>\|]{0,63}$
(assert (str.in_re X (re.++ (re.* (str.to_re "/")) (re.* (re.++ (re.union (str.to_re "/") (str.to_re "\u{5c}") (str.to_re " ") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|") (str.to_re ".")) ((_ re.loop 0 63) (re.union (str.to_re "/") (str.to_re "\u{5c}") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re "/"))) (re.union (str.to_re "/") (str.to_re "\u{5c}") (str.to_re " ") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|") (str.to_re ".")) ((_ re.loop 0 63) (re.union (str.to_re "/") (str.to_re "\u{5c}") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re "\u{0a}"))))
; /\.php\?j=1&k=[0-9](i=[0-9])?$/U
(assert (not (str.in_re X (re.++ (str.to_re "/.php?j=1&k=") (re.range "0" "9") (re.opt (re.++ (str.to_re "i=") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
