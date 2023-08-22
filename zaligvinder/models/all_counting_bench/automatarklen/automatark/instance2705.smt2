(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A[^\n\r]*quick\x2Eqsrch\x2Ecom.*www\.searchinweb\.com
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "quick.qsrch.com") (re.* re.allchar) (str.to_re "www.searchinweb.com\u{0a}")))))
; [A-Za-z]{2}[0-9]{1,6}|[0-9]{1,8}
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ ((_ re.loop 1 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
