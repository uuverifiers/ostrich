(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (ES-?)?([0-9A-Z][0-9]{7}[A-Z])|([A-Z][0-9]{7}[0-9A-Z])
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re "ES") (re.opt (str.to_re "-")))) (re.union (re.range "0" "9") (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9")) (re.range "A" "Z")) (re.++ (str.to_re "\u{0a}") (re.range "A" "Z") ((_ re.loop 7 7) (re.range "0" "9")) (re.union (re.range "0" "9") (re.range "A" "Z")))))))
; HTTPwwwProbnymomspyo\u{2f}zowy
(assert (not (str.in_re X (str.to_re "HTTPwwwProbnymomspyo/zowy\u{0a}"))))
; httphost[^\n\r]*www\x2Emaxifiles\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "httphost") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "www.maxifiles.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
