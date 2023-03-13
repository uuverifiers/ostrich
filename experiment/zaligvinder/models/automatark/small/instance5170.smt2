(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[\u{22}\u{27}]?[^\n]*\u{2e}pif[\u{22}\u{27}\s]/si
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pif") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/si\u{0a}")))))
; ^(FR)?\s?[A-Z0-9-[IO]]{2}[0-9]{9}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "FR")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "[") (str.to_re "I") (str.to_re "O")) ((_ re.loop 2 2) (str.to_re "]")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([1-9]|0[1-9]|[12][0-9]|3[01])(-|/)(([1-9]|0[1-9])|(1[0-2]))(-|/)(([0-9][0-9])|([0-9][0-9][0-9][0-9]))$
(assert (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9"))) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /\u{2e}mka([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.mka") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^09(73|74|05|06|15|16|17|26|27|35|36|37|79|38|07|08|09|10|12|18|19|20|21|28|29|30|38|39|89|99|22|23|32|33)\d{3}\s?\d{4}
(assert (str.in_re X (re.++ (str.to_re "09") (re.union (str.to_re "73") (str.to_re "74") (str.to_re "05") (str.to_re "06") (str.to_re "15") (str.to_re "16") (str.to_re "17") (str.to_re "26") (str.to_re "27") (str.to_re "35") (str.to_re "36") (str.to_re "37") (str.to_re "79") (str.to_re "38") (str.to_re "07") (str.to_re "08") (str.to_re "09") (str.to_re "10") (str.to_re "12") (str.to_re "18") (str.to_re "19") (str.to_re "20") (str.to_re "21") (str.to_re "28") (str.to_re "29") (str.to_re "30") (str.to_re "38") (str.to_re "39") (str.to_re "89") (str.to_re "99") (str.to_re "22") (str.to_re "23") (str.to_re "32") (str.to_re "33")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
