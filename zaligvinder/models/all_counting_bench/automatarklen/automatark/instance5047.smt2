(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x7D\x7BTrojan\x3A\w+by\d+toetbuviaebe\u{2f}eqv\.bvvuplink\x2Eco\x2Ekrwv=Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "}{Trojan:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "by") (re.+ (re.range "0" "9")) (str.to_re "toetbuviaebe/eqv.bvvuplink.co.krwv=Host:\u{0a}")))))
; (IE-?)?[0-9][0-9A-Z\+\*][0-9]{5}[A-Z]
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "IE") (re.opt (str.to_re "-")))) (re.range "0" "9") (re.union (re.range "0" "9") (re.range "A" "Z") (str.to_re "+") (str.to_re "*")) ((_ re.loop 5 5) (re.range "0" "9")) (re.range "A" "Z") (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
