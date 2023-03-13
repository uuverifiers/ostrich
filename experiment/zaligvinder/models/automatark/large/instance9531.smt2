(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/setup\/[a-z0-9!-]{50}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//setup/") ((_ re.loop 50 50) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "!") (str.to_re "-"))) (str.to_re "/Ui\u{0a}")))))
; /filename=[^\n]*\u{2e}rtx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rtx/i\u{0a}")))))
; ^((\+|00)[1-9]{1,3})?(\-| {0,1})?(([\d]{0,3})(\-| {0,1})?([\d]{5,11})){1}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "00")) ((_ re.loop 1 3) (re.range "1" "9")))) (re.opt (re.union (str.to_re "-") (re.opt (str.to_re " ")))) ((_ re.loop 1 1) (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (re.opt (str.to_re " ")))) ((_ re.loop 5 11) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)
