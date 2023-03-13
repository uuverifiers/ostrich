(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; OSSProxy\d+X-Mailer\x3Abacktrust\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "OSSProxy") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer:\u{13}backtrust.com\u{0a}")))))
; (^\d{5}\-\d{3}$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))))))
; ^<a[^>]*(http://[^"]*)[^>]*>([ 0-9a-zA-Z]+)</a>$
(assert (str.in_re X (re.++ (str.to_re "<a") (re.* (re.comp (str.to_re ">"))) (re.* (re.comp (str.to_re ">"))) (str.to_re ">") (re.+ (re.union (str.to_re " ") (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "</a>\u{0a}http://") (re.* (re.comp (str.to_re "\u{22}"))))))
(check-sat)
