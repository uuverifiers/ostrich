(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mny/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mny/i\u{0a}"))))
; ((\d{4})|(\d{2}))|(0?[2469]|11)(-|\/)((0[0-9])|([12])([0-9]?)|(3[0]?))(-|\/)((0?[13578]|10|12)(-|\/)((0[0-9])|([12])([0-9]?)|(3[01]?))(-|\/)((\d{4}|\d{2})))
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.opt (re.range "0" "9"))) (re.++ (str.to_re "3") (re.opt (str.to_re "0")))) (re.union (str.to_re "-") (str.to_re "/")) (str.to_re "\u{0a}") (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (str.to_re "10") (str.to_re "12")) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.opt (re.range "0" "9"))) (re.++ (str.to_re "3") (re.opt (re.union (str.to_re "0") (str.to_re "1"))))) (re.union (str.to_re "-") (str.to_re "/")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))))))
; thesearchresltLoggerHost\x3ABetaHWAEHost\x3Ais
(assert (str.in_re X (str.to_re "thesearchresltLoggerHost:BetaHWAEHost:is\u{0a}")))
; ^([01][012]|0[1-9])/([0-2][0-9]|[3][0-1])/([0-9][0-9][0-9][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2"))) (re.++ (str.to_re "0") (re.range "1" "9"))) (str.to_re "/") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/\u{0a}") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))))
; (^\+[0-9]{2}|^\+[0-9]{2}\(0\)|^\(\+[0-9]{2}\)\(0\)|^00[0-9]{2}|^0)([0-9]{9}$|[0-9\-\s]{10}$)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "+") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "+") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "(0)")) (re.++ (str.to_re "(+") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")(0)")) (re.++ (str.to_re "00") ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "0")) (re.union ((_ re.loop 9 9) (re.range "0" "9")) ((_ re.loop 10 10) (re.union (re.range "0" "9") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
