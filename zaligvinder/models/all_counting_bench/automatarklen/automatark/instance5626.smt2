(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}paq8o/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".paq8o/i\u{0a}"))))
; ( xmlns:.*=[",'].*[",'])|( xmlns=[",'].*[",'])
(assert (not (str.in_re X (re.union (re.++ (str.to_re " xmlns:") (re.* re.allchar) (str.to_re "=") (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'")) (re.* re.allchar) (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'"))) (re.++ (str.to_re "\u{0a} xmlns=") (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'")) (re.* re.allchar) (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'")))))))
; ^(000-)(\\d{5}-){2}\\d{3}$
(assert (not (str.in_re X (re.++ (str.to_re "000-") ((_ re.loop 2 2) (re.++ (str.to_re "\u{5c}") ((_ re.loop 5 5) (str.to_re "d")) (str.to_re "-"))) (str.to_re "\u{5c}") ((_ re.loop 3 3) (str.to_re "d")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
