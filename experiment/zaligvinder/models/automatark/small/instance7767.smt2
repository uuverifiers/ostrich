(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Theef2offers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "Theef2offers.bullseye-network.com\u{0a}"))))
; (^(6011)\d{12}$)|(^(65)\d{14}$)
(assert (not (str.in_re X (re.union (re.++ (str.to_re "6011") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}65") ((_ re.loop 14 14) (re.range "0" "9")))))))
; /filename=[^\n]*\u{2e}psd/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".psd/i\u{0a}")))))
(check-sat)
