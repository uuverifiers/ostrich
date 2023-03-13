(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(1)?(-|.)?(\()?([0-9]{3})(\))?(-|.)?([0-9]{3})(-|.)?([0-9]{4})/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re "-") re.allchar)) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") re.allchar)) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") re.allchar)) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/\u{0a}")))))
; &
(assert (not (str.in_re X (str.to_re "&\u{0a}"))))
; (\s(\bon[a-zA-Z][a-z]+)\s?\=\s?[\'\"]?(javascript\:)?[\w\(\),\' ]*;?[\'\"]?)+
(assert (str.in_re X (re.++ (re.+ (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (re.opt (str.to_re "javascript:")) (re.* (re.union (str.to_re "(") (str.to_re ")") (str.to_re ",") (str.to_re "'") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ";")) (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re "on") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.+ (re.range "a" "z")))) (str.to_re "\u{0a}"))))
; ^\$?\d{1,2}\,\d{3}?\,\d{3}?(\.(\d{2}))$|^\$?\d{1,3}?\,\d{3}?(\.(\d{2}))$|^\$?\d{1,3}?(\.(\d{2}))$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "$")) ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "$")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "$")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}.") ((_ re.loop 2 2) (re.range "0" "9")))))))
; [1-9][0-9]
(assert (not (str.in_re X (re.++ (re.range "1" "9") (re.range "0" "9") (str.to_re "\u{0a}")))))
(check-sat)
