(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1][12]|[0]?[1-9])[\/-]([3][01]|[12]\d|[0]?[1-9])[\/-](\d{4}|\d{2})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "1") (str.to_re "2"))) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; Explorer\x2Fsto=notificationfind
(assert (str.in_re X (str.to_re "Explorer/sto=notification\u{13}find\u{0a}")))
; %3fSupremeSoftwareoffers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "%3fSupremeSoftwareoffers.bullseye-network.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
