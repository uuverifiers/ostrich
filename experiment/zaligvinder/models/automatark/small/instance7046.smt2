(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\+[0-9]{1,3}\([0-9]{3}\)[0-9]{7}$
(assert (str.in_re X (re.++ (str.to_re "+") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; IPAnaloffers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "IPAnaloffers.bullseye-network.com\u{0a}"))))
; /([^\u{00}-\xFF]\s*)/u
(assert (not (str.in_re X (re.++ (str.to_re "//u\u{0a}") (re.range "\u{00}" "\u{ff}") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
(check-sat)
