(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <[^>]+>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.+ (re.comp (str.to_re ">"))) (str.to_re ">\u{0a}")))))
; -i%3fUser-Agent\x3Awww\u{2e}proventactics\u{2e}com
(assert (not (str.in_re X (str.to_re "-i%3fUser-Agent:www.proventactics.com\u{0a}"))))
; ^\$?([1-9][0-9]{3,}(\.\d{2})?|(\d{1,3}\,\d{3}|\d{1,3}\,\d{3}(\.\d{2})?)|(\d{1,3}\,\d{3}|\d{1,3}\,\d{3}\,\d{3}(\.\d{2})?)*)?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.opt (re.union (re.++ (re.range "1" "9") (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.* (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))) (str.to_re "\u{0a}"))))
(check-sat)
