(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+-]? *100(\.0{0,2})? *%?$|^[+-]? *\d{1,2}(\.\d{1,2})? *%?$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (str.to_re " ")) (str.to_re "100") (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (str.to_re "0")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%"))) (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (str.to_re " ")) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%")) (str.to_re "\u{0a}"))))))
; /filename=[^\n]*\u{2e}mpg/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mpg/i\u{0a}"))))
; \b(0?[1-9]|1[0-2])(\-)(0?[1-9]|1[0-9]|2[0-9]|3[0-1])(\-)(0[0-8])\b
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "-") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "-\u{0a}0") (re.range "0" "8"))))
; NetControl\x2EServerNetTrackerSiLENTHost\x3A
(assert (str.in_re X (str.to_re "NetControl.Server\u{13}NetTrackerSiLENTHost:\u{0a}")))
; /([^\u{00}-\xFF]\s*)/u
(assert (str.in_re X (re.++ (str.to_re "//u\u{0a}") (re.range "\u{00}" "\u{ff}") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
(assert (> (str.len X) 10))
(check-sat)
