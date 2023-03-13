(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}hlp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".hlp/i\u{0a}"))))
; ^(\+{1}|00)\s{0,1}([0-9]{3}|[0-9]{2})\s{0,1}\-{0,1}\s{0,1}([0-9]{2}|[1-9]{1})\s{0,1}\-{0,1}\s{0,1}([0-9]{8}|[0-9]{7})
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (str.to_re "+")) (str.to_re "00")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 8 8) (re.range "0" "9")) ((_ re.loop 7 7) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^([0-9]{2})?(\([0-9]{2})\)([0-9]{3}|[0-9]{4})-[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re ")") (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}(") ((_ re.loop 2 2) (re.range "0" "9")))))
; ^((\+989)|(989)|(00989)|(09|9))([1|2|3][0-9]\d{7}$)
(assert (str.in_re X (re.++ (re.union (str.to_re "+989") (str.to_re "989") (str.to_re "00989") (str.to_re "09") (str.to_re "9")) (str.to_re "\u{0a}") (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2") (str.to_re "3")) (re.range "0" "9") ((_ re.loop 7 7) (re.range "0" "9")))))
; /filename=[^\n]*\u{2e}xpm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xpm/i\u{0a}")))))
(check-sat)
