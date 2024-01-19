(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0][1-9]|[1|2][0-9]|[3][0|1])[./-]([0][1-9]|[1][0-2])[./-]([0-9]{4})|(([0][1-9]|[1|2][0-9]|[3][0|1])[./-]([0][1-9]|[1][0-2])[./-]([0-9]{4}))[ ]([0|1][0-2])[:](([0-5][0-9]))([:](([0-5][0-9])))?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re " :") (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")) (re.range "0" "2") (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^(\+?420)? ?[0-9]{3} ?[0-9]{3} ?[0-9]{3}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (str.to_re "420"))) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(N[BLSTU]|[AMN]B|[BQ]C|ON|PE|SK)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "N") (re.union (str.to_re "B") (str.to_re "L") (str.to_re "S") (str.to_re "T") (str.to_re "U"))) (re.++ (re.union (str.to_re "A") (str.to_re "M") (str.to_re "N")) (str.to_re "B")) (re.++ (re.union (str.to_re "B") (str.to_re "Q")) (str.to_re "C")) (str.to_re "ON") (str.to_re "PE") (str.to_re "SK")) (str.to_re "\u{0a}")))))
; Subject\x3A\swww\x2Esearchwords\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Subject:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.searchwords.com\u{0a}"))))
; LOG\s+spyblpatHost\x3Ais\x2Ephp
(assert (not (str.in_re X (re.++ (str.to_re "LOG") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblpatHost:is.php\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
