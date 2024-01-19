(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z]+)://([a-zA-Z0-9_\-]+)((\.[a-zA-Z0-9_\-]+|[0-9]{1,3})+)\.([a-zA-Z]{2,6}|[0-9]{1,3})((:[0-9]+)?)((/[a-zA-Z0-9_\-,.;=%]*)*)((\?[a-zA-Z0-9_\-,.;=&%]*)?)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.+ (re.union (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-")))) ((_ re.loop 1 3) (re.range "0" "9")))) (str.to_re ".") (re.union ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 3) (re.range "0" "9"))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.* (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re ",") (str.to_re ".") (str.to_re ";") (str.to_re "=") (str.to_re "%"))))) (re.opt (re.++ (str.to_re "?") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re ",") (str.to_re ".") (str.to_re ";") (str.to_re "=") (str.to_re "&") (str.to_re "%"))))) (str.to_re "\u{0a}"))))
; \d+,?\d+\$?
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ",")) (re.+ (re.range "0" "9")) (re.opt (str.to_re "$")) (str.to_re "\u{0a}")))))
; User-Agent\x3A\s+information\swww\x2Etopadwarereviews\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "information") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.topadwarereviews.com\u{0a}")))))
; ^([EV])?\d{3,3}(\.\d{1,2})?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "E") (str.to_re "V"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
