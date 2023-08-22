(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.union (str.to_re ":") (str.to_re "-")))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "\u{0a}"))))
; SAcc\d+Seconds\-\x2Fcommunicatortb
(assert (not (str.in_re X (re.++ (str.to_re "SAcc") (re.+ (re.range "0" "9")) (str.to_re "Seconds-/communicatortb\u{0a}")))))
; client\x2Ebaigoo\x2EcomUser\x3A
(assert (not (str.in_re X (str.to_re "client.baigoo.comUser:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
