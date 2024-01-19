(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; https?://[\d.A-Za-z-]+\.[A-Za-z]{2,6}/?
(assert (not (str.in_re X (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://") (re.+ (re.union (re.range "0" "9") (str.to_re ".") (re.range "A" "Z") (re.range "a" "z") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re "/")) (str.to_re "\u{0a}")))))
; \d{4}-\d{4}-\d{2}|\d{5}-\d{3}-\d{2}|\d{5}-\d{4}-\d{1}|\d{5}-\*\d{3}-\d{2}
(assert (str.in_re X (re.union (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-*") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /mmpool[^\u{00}]*?([\u{3b}\u{7c}\u{26}\u{60}]|\u{24}\u{28})/
(assert (not (str.in_re X (re.++ (str.to_re "/mmpool") (re.* (re.comp (str.to_re "\u{00}"))) (re.union (str.to_re "$(") (str.to_re ";") (str.to_re "|") (str.to_re "&") (str.to_re "`")) (str.to_re "/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
