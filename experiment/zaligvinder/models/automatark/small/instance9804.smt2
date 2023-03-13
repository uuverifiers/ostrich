(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^[0][.]{1}[0-9]{0,}[1-9]+[0-9]{0,}$)|(^[1-9]+[0-9]{0,}[.]?[0-9]{0,}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (str.to_re ".")) (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9"))))))
; ^(\d{4})\D?(0[1-9]|1[0-2])\D?([12]\d|0[1-9]|3[01])(\D?([01]\d|2[0-3])\D?([0-5]\d)\D?([0-5]\d)?)?$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.opt (re.++ (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.opt (re.comp (re.range "0" "9"))) (re.opt (re.comp (re.range "0" "9"))) (re.opt (re.++ (re.range "0" "5") (re.range "0" "9"))) (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; IPUSER-Host\x3AUser-Agent\x3A\x2Fsearchfast\x2F
(assert (not (str.in_re X (str.to_re "IPUSER-Host:User-Agent:/searchfast/\u{0a}"))))
; User-Agent\x3A\s+information\swww\x2Etopadwarereviews\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "information") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.topadwarereviews.com\u{0a}"))))
; ^(\d{4})-((0[1-9])|(1[0-2]))-(0[1-9]|[12][0-9]|3[01])$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "\u{0a}"))))
(check-sat)
