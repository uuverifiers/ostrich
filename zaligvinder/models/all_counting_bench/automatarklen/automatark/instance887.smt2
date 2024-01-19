(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [-+]((0[0-9]|1[0-3]):([03]0|45)|14:00)
(assert (str.in_re X (re.++ (re.union (str.to_re "-") (str.to_re "+")) (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "3"))) (str.to_re ":") (re.union (re.++ (re.union (str.to_re "0") (str.to_re "3")) (str.to_re "0")) (str.to_re "45"))) (str.to_re "14:00")) (str.to_re "\u{0a}"))))
; ^100$|^[0-9]{1,2}$|^[0-9]{1,2}\,[0-9]{1,3}$
(assert (not (str.in_re X (re.union (str.to_re "100") ((_ re.loop 1 2) (re.range "0" "9")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; httphost\dActivityfilename=\u{22}
(assert (not (str.in_re X (re.++ (str.to_re "httphost") (re.range "0" "9") (str.to_re "Activityfilename=\u{22}\u{0a}")))))
; \.fcgi[^\n\r]*Host\x3A\s\x5D\u{25}20\x5BPort_NETObserveTM_SEARCH3
(assert (str.in_re X (re.++ (str.to_re ".fcgi") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "]%20[Port_NETObserveTM_SEARCH3\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
