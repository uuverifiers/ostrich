(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; st=\s+www\.iggsey\.com.*BackAtTaCkadserver\.warezclient\.com
(assert (str.in_re X (re.++ (str.to_re "st=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.iggsey.com") (re.* re.allchar) (str.to_re "BackAtTaCkadserver.warezclient.com\u{0a}"))))
; \b([2-9][p-z][a-h][2-9]{1,2}[a-z]+[p-z][2-9][p-z][2-9][p-z]|[a-z][a-z]+\d{2}[a-z]|[2-9][p-z]{2}[a-h][2-9]{1,2}[a-z]+[p-z][2-9]{3}[p-z]|\d{12}|[2-9][p-z][a-h][2-9][a-z0-9]+[p-z][2-9]{3}[p-z])\b
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "2" "9") (re.range "p" "z") (re.range "a" "h") ((_ re.loop 1 2) (re.range "2" "9")) (re.+ (re.range "a" "z")) (re.range "p" "z") (re.range "2" "9") (re.range "p" "z") (re.range "2" "9") (re.range "p" "z")) (re.++ (re.range "a" "z") (re.+ (re.range "a" "z")) ((_ re.loop 2 2) (re.range "0" "9")) (re.range "a" "z")) (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "p" "z")) (re.range "a" "h") ((_ re.loop 1 2) (re.range "2" "9")) (re.+ (re.range "a" "z")) (re.range "p" "z") ((_ re.loop 3 3) (re.range "2" "9")) (re.range "p" "z")) ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (re.range "2" "9") (re.range "p" "z") (re.range "a" "h") (re.range "2" "9") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.range "p" "z") ((_ re.loop 3 3) (re.range "2" "9")) (re.range "p" "z"))) (str.to_re "\u{0a}")))))
; \d{1,2}d \d{1,2}h
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "d ") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "h\u{0a}")))))
; CZ\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}|CZ\d{22}
(assert (str.in_re X (re.++ (str.to_re "CZ") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 22 22) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(check-sat)
