(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-1]?[0-9]{1}|2[0-3]{1}):([0-5]{1}[0-9]{1})$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "2") ((_ re.loop 1 1) (re.range "0" "3")))) (str.to_re ":\u{0a}") ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")))))
; /^\/[\w-]{48}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 48 48) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/U\u{0a}")))))
; ^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.range "0" "9") (re.opt (re.union (re.++ re.allchar (re.* (re.range "0" "9")) (re.range "0" "9")) (re.++ (str.to_re ",") (re.* (re.range "0" "9")) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\u{2e}otf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.otf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^((67\d{2})|(4\d{3})|(5[1-5]\d{2})|(6011))-?\s?\d{4}-?\s?\d{4}-?\s?\d{4}|3[4,7]\d{13}$
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "67") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "5") (re.range "1" "5") ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "6011")) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "4") (str.to_re ",") (str.to_re "7")) ((_ re.loop 13 13) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(check-sat)
