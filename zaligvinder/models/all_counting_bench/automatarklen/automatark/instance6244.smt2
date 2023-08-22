(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \.fcgi[^\n\r]*Host\x3A\s\x5D\u{25}20\x5BPort_NETObserveTM_SEARCH3
(assert (str.in_re X (re.++ (str.to_re ".fcgi") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "]%20[Port_NETObserveTM_SEARCH3\u{0a}"))))
; User-Agent\u{3a}User-Agent\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}"))))
; ^[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3})$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; /[a-z]{2}_[a-z0-9]{8}\.mod/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "_") ((_ re.loop 8 8) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".mod/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
