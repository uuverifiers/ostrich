(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([6011]{4})([0-9]{12})$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (str.to_re "6") (str.to_re "0") (str.to_re "1"))) ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; upgrade\x2Eqsrch\x2Einfo.*report.*Host\x3A.*Host\x3Akwd-i%3fUser-Agent\x3Awww\u{2e}proventactics\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "upgrade.qsrch.info") (re.* re.allchar) (str.to_re "report") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "Host:kwd-i%3fUser-Agent:www.proventactics.com\u{0a}"))))
; ^\d{1,2}\/\d{2,4}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
