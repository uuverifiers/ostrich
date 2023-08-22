(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([987]{1})(\d{1})(\d{8})
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "9") (str.to_re "8") (str.to_re "7"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}mpg/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mpg/i\u{0a}"))))
; connectedNodes\s+insert\s+haveFTUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "connectedNodes") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "insert") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "haveFTUser-Agent:\u{0a}")))))
; (25[0-5]|2[0-4][0-9]|[1][0-9]?[0-9]?|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[1][0-9]?[0-9]?|[1-9][0-9]?|[0])\.(25[0-5]|2[0-4][0-9]|[1][0-9]?[0-9]?|[1-9][0-9]?|[0])\.(25[0-5]|2[0-4][0-9]|[1][0-9]?[0-9]?|[1-9][0-9]?)
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9")))) (str.to_re ".") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9"))) (str.to_re "0")) (str.to_re ".") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9"))) (str.to_re "0")) (str.to_re ".") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
