(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Theef2offers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "Theef2offers.bullseye-network.com\u{0a}"))))
; /filename=[^\n]*\u{2e}png/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".png/i\u{0a}"))))
; /^\u{2f}[0-9a-f]+$/iU
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "/iU\u{0a}")))))
; \d{5,12}|\d{1,10}\.\d{1,10}\.\d{1,10}|\d{1,10}\.\d{1,10}
(assert (not (str.in_re X (re.union ((_ re.loop 5 12) (re.range "0" "9")) (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9"))) (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(check-sat)
