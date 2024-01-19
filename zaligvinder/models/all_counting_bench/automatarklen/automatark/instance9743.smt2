(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A.*Host\x3A\dName=Your\+Host\+is\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "Host:") (re.range "0" "9") (str.to_re "Name=Your+Host+is:\u{0a}")))))
; ^\d{1,2}\.\d{3}\.\d{3}[-][0-9kK]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.union (re.range "0" "9") (str.to_re "k") (str.to_re "K"))) (str.to_re "\u{0a}"))))
; Host\x3A\supgrade\x2Eqsrch\x2Einfox2Fie\.aspdcww\x2Edmcast\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "upgrade.qsrch.infox2Fie.aspdcww.dmcast.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
