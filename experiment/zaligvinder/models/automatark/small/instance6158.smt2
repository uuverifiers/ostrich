(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Software\s+User-Agent\x3A.*FictionalUser-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Software") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "FictionalUser-Agent:User-Agent:\u{0a}")))))
; ^[+-]? *(\$)? *((\d+)|(\d{1,3})(\,\d{3})*)(\.\d{0,2})?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (str.to_re " ")) (re.opt (str.to_re "$")) (re.* (str.to_re " ")) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
