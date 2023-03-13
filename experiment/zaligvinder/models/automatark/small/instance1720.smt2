(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\bobj\u{0a}\u{20}*?\/Pattern\u{20}*?\u{0a}endobj\b/i
(assert (not (str.in_re X (re.++ (str.to_re "/obj\u{0a}") (re.* (str.to_re " ")) (str.to_re "/Pattern") (re.* (str.to_re " ")) (str.to_re "\u{0a}endobj/i\u{0a}")))))
; function.*WEBCAM-.*User-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "function") (re.* re.allchar) (str.to_re "WEBCAM-") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}"))))
; xpsp2-\s+spyblpatHost\x3Ais\x2EphpBarFrom\x3A
(assert (not (str.in_re X (re.++ (str.to_re "xpsp2-") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblpatHost:is.phpBarFrom:\u{0a}")))))
; ^(http|https|ftp)\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&%\$#\=~])*$
(assert (str.in_re X (re.++ (re.union (str.to_re "http") (str.to_re "https") (str.to_re "ftp")) (str.to_re "://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re ":") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (re.opt (str.to_re "/")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "?") (str.to_re ",") (str.to_re "'") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~"))) (str.to_re "\u{0a}"))))
; (\d{1,3},(\d{3},)*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{3})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
(check-sat)
