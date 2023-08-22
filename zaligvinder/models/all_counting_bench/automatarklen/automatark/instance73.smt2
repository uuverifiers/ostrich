(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([Cc][Hh][Aa][Nn][Dd][Aa][Nn].*?)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "C") (str.to_re "c")) (re.union (str.to_re "H") (str.to_re "h")) (re.union (str.to_re "A") (str.to_re "a")) (re.union (str.to_re "N") (str.to_re "n")) (re.union (str.to_re "D") (str.to_re "d")) (re.union (str.to_re "A") (str.to_re "a")) (re.union (str.to_re "N") (str.to_re "n")) (re.* re.allchar))))
; Supreme\d+Host\x3A\d+yxegtd\u{2f}efcwgHost\x3ATPSystem
(assert (not (str.in_re X (re.++ (str.to_re "Supreme") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "yxegtd/efcwgHost:TPSystem\u{0a}")))))
; ^[^\\\./:\*\?\"<>\|]{1}[^\\/:\*\?\"<>\|]{0,254}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "\u{5c}") (str.to_re ".") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) ((_ re.loop 0 254) (re.union (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
