(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((Fred|Wilma)\s+Flintstone|(Barney|Betty)\s+Rubble)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "Fred") (str.to_re "Wilma")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Flintstone")) (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "RubbleB") (re.union (str.to_re "arney") (str.to_re "etty")))) (str.to_re "\u{0a}")))))
; ^(FR)?\s?[A-Z0-9-[IO]]{2}[0-9]{9}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "FR")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "[") (str.to_re "I") (str.to_re "O")) ((_ re.loop 2 2) (str.to_re "]")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /[a-z]{2}_[a-z0-9]{8}\.mod/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "_") ((_ re.loop 8 8) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".mod/Ui\u{0a}")))))
; \x2Fdesktop\x2FSystemwwwfromToolbartheServer\x3Awww\x2Esearchreslt\x2Ecom
(assert (str.in_re X (str.to_re "/desktop/SystemwwwfromToolbartheServer:www.searchreslt.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
