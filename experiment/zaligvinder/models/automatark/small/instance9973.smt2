(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; %3fSupremeSoftwareoffers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "%3fSupremeSoftwareoffers.bullseye-network.com\u{0a}"))))
; ^[2-9]\d{2}-\d{3}-\d{4}$
(assert (not (str.in_re X (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
