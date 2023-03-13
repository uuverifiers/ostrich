(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b([0]?[1-9]|[1,2]\d|3[0,1])[-/]([0]?[1-9]|[1][0,1,2])[-/](\d{1,2}|[1][9]\d\d|[2][0]\d\d)\b
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re ",") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "1")))) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "1") (str.to_re "2")))) (re.union (str.to_re "-") (str.to_re "/")) (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "20") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; \x2Fbar_pl\x2Fchk_bar\.fcgiTrojanHost\x3A
(assert (not (str.in_re X (str.to_re "/bar_pl/chk_bar.fcgiTrojanHost:\u{0a}"))))
; ^[a-zA-Z][a-zA-Z\-' ]*[a-zA-Z ]$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "-") (str.to_re "'") (str.to_re " "))) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re " ")) (str.to_re "\u{0a}"))))
; ^1?[1-2]$|^[1-9]$|^[1]0$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "1")) (re.range "1" "2")) (re.range "1" "9") (str.to_re "10\u{0a}"))))
; forum=From\u{3a}comTencentTravelerBackAtTaCkExplorer
(assert (not (str.in_re X (str.to_re "forum=From:comTencentTravelerBackAtTaCkExplorer\u{0a}"))))
(check-sat)
