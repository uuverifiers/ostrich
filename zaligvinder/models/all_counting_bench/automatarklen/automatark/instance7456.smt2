(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^[0-9]{0,10}$)
(assert (str.in_re X (re.++ ((_ re.loop 0 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \d{1,2}d \d{1,2}h
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "d ") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "h\u{0a}")))))
; www\x2Emirarsearch\x2Ecom
(assert (str.in_re X (str.to_re "www.mirarsearch.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
