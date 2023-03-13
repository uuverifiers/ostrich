(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((((0?[13578])|(1[02]))[\-]?((0?[1-9]|[0-2][0-9])|(3[01])))|(((0?[469])|(11))[\-]?((0?[1-9]|[0-2][0-9])|(30)))|(0?[2][\-]?(0?[1-9]|[0-2][0-9])))[\-]?\d{2}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (re.opt (str.to_re "-")) (re.union (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (re.opt (str.to_re "-")) (re.union (str.to_re "30") (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (re.opt (str.to_re "0")) (str.to_re "2") (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "0" "2") (re.range "0" "9"))))) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \x7D\x7BTrojan\x3A\w+by\d+toetbuviaebe\u{2f}eqv\.bvvuplink\x2Eco\x2Ekrwv=Host\x3A
(assert (str.in_re X (re.++ (str.to_re "}{Trojan:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "by") (re.+ (re.range "0" "9")) (str.to_re "toetbuviaebe/eqv.bvvuplink.co.krwv=Host:\u{0a}"))))
(check-sat)
