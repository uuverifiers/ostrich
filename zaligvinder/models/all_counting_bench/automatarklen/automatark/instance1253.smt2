(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}dvr-ms/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dvr-ms/i\u{0a}")))))
; User-Agent\x3A[^\n\r]*quick\x2Eqsrch\x2Ecom.*www\.searchinweb\.com
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "quick.qsrch.com") (re.* re.allchar) (str.to_re "www.searchinweb.com\u{0a}"))))
; ^[A-Z][a-z]+((e(m|ng)|str)a)$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "e") (re.union (str.to_re "m") (str.to_re "ng"))) (str.to_re "str")) (str.to_re "a")))))
; /filename=[^\n]*\u{2e}png/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".png/i\u{0a}")))))
; ^[A-Z]{2}-[0-9]{2}-[0-9]{2}|[0-9]{2}-[0-9]{2}-[A-Z]{2}|[0-9]{2}-[A-Z]{2}-[0-9]{2}|[A-Z]{2}-[0-9]{2}-[A-Z]{2}|[A-Z]{2}-[A-Z]{2}-[0-9]{2}|}|[0-9]{2}-[A-Z]{2}-[A-Z]{2}|[0-9]{2}-[A-Z]{3}-[0-9]{1}|[0-9]{1}-[A-Z]{3}-[0-9]{2}$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "A" "Z"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "A" "Z"))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "}") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 2 2) (re.range "A" "Z"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
