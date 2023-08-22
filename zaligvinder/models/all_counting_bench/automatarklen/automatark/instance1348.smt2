(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\s+GETwww\x2Eoemji\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "GETwww.oemji.com\u{0a}")))))
; \x2Fbar_pl\x2Fchk\.fcgiHWAEcom\x2Findex\.php\?tpid=
(assert (not (str.in_re X (str.to_re "/bar_pl/chk.fcgiHWAEcom/index.php?tpid=\u{0a}"))))
; t=[^\n\r]*Host\x3A\s+Basicaohobygi\u{2f}zwiw
(assert (str.in_re X (re.++ (str.to_re "t=") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Basicaohobygi/zwiw\u{0a}"))))
; ^[+][0-9]\d{2}-\d{3}-\d{4}$
(assert (str.in_re X (re.++ (str.to_re "+") (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
