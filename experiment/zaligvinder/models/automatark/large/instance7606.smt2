(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((4(\d{12}|\d{15}))|(5\d{15})|(6011\d{12})|(3(4|7)\d{13}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "4") (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 15 15) (re.range "0" "9")))) (re.++ (str.to_re "5") ((_ re.loop 15 15) (re.range "0" "9"))) (re.++ (str.to_re "6011") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "4") (str.to_re "7")) ((_ re.loop 13 13) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(\d{2}-\d{2})*$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; YAHOODesktopHost\u{3a}LOGHost\x3AtvshowticketsResultsFROM\x3A
(assert (str.in_re X (str.to_re "YAHOODesktopHost:LOGHost:tvshowticketsResultsFROM:\u{0a}")))
; /\/$/U
(assert (not (str.in_re X (str.to_re "///U\u{0a}"))))
; ^(F-)?((2[A|B])|[0-9]{2})[0-9]{3}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "F-")) (re.union (re.++ (str.to_re "2") (re.union (str.to_re "A") (str.to_re "|") (str.to_re "B"))) ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
