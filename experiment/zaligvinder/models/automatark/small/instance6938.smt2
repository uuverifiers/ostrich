(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-1]?\d|2[0-3])([:]?[0-5]\d)?([:]?|[0-5]\d)?\s?(A|AM|P|p|a|PM|am|pm|pM|aM|Am|Pm)?$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.opt (re.++ (re.opt (str.to_re ":")) (re.range "0" "5") (re.range "0" "9"))) (re.opt (re.union (re.opt (str.to_re ":")) (re.++ (re.range "0" "5") (re.range "0" "9")))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "A") (str.to_re "AM") (str.to_re "P") (str.to_re "p") (str.to_re "a") (str.to_re "PM") (str.to_re "am") (str.to_re "pm") (str.to_re "pM") (str.to_re "aM") (str.to_re "Am") (str.to_re "Pm"))) (str.to_re "\u{0a}"))))
; ^[A-Z]{1}-[0-9]{7}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
