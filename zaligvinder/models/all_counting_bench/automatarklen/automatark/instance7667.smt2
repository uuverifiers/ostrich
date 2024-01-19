(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]*[1-9]+[0-9]*$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}$
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; Server\d+dcww\x2Edmcast\x2EcomdistID=Host\u{3a}Subject\x3A
(assert (str.in_re X (re.++ (str.to_re "Server") (re.+ (re.range "0" "9")) (str.to_re "dcww.dmcast.comdistID=Host:Subject:\u{0a}"))))
; ^[A-Z]+[A-Z0-9,\x5F]*$
(assert (not (str.in_re X (re.++ (re.+ (re.range "A" "Z")) (re.* (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re ",") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}qcp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".qcp/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
