(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [a-z0-9][a-z0-9_\.-]{0,}[a-z0-9]\.[a-z0-9][a-z0-9_\.-]{0,}[a-z0-9][\.][cn]{2,4}
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")) (str.to_re ".") (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 4) (re.union (str.to_re "c") (str.to_re "n"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}wma/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wma/i\u{0a}")))))
; sql.*badurl\x2Egrandstreetinteractive\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "sql") (re.* re.allchar) (str.to_re "badurl.grandstreetinteractive.com\u{0a}"))))
; /[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{13}\u{28}\x0A\u{51}/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 13 13) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "(\u{0a}Q/\u{0a}")))))
; /filename=[^\n]*\u{2e}gz/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".gz/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
