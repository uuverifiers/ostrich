(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Ealtnet\x2Ecom[^\n\r]*Host\x3A
(assert (str.in_re X (re.++ (str.to_re "www.altnet.com\u{1b}") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; ^(\d{4})\D?(0[1-9]|1[0-2])\D?([12]\d|0[1-9]|3[01])(\D?([01]\d|2[0-3])\D?([0-5]\d)\D?([0-5]\d)?)?$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.opt (re.++ (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.opt (re.comp (re.range "0" "9"))) (re.opt (re.comp (re.range "0" "9"))) (re.opt (re.++ (re.range "0" "5") (re.range "0" "9"))) (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
