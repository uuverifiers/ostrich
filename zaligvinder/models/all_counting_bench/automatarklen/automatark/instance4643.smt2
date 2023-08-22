(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \.fcgi[^\n\r]*Host\x3A\s\x5D\u{25}20\x5BPort_NETObserveTM_SEARCH3
(assert (str.in_re X (re.++ (str.to_re ".fcgi") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "]%20[Port_NETObserveTM_SEARCH3\u{0a}"))))
; /^\/\w{1,2}\/\w{1,3}\.class$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".class/U\u{0a}"))))
; ((\d{1,5})*\.*(\d{0,3})"[W|D|H|DIA][X|\s]).*
(assert (not (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}") (re.* ((_ re.loop 1 5) (re.range "0" "9"))) (re.* (str.to_re ".")) ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re "\u{22}") (re.union (str.to_re "W") (str.to_re "|") (str.to_re "D") (str.to_re "H") (str.to_re "I") (str.to_re "A")) (re.union (str.to_re "X") (str.to_re "|") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
(assert (> (str.len X) 10))
(check-sat)
