(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; t=ProtoUser-Agent\x3Aquick\x2Eqsrch\x2Ecom
(assert (not (str.in_re X (str.to_re "t=ProtoUser-Agent:quick.qsrch.com\u{0a}"))))
; ^((https?|ftp)\://((\[?(\d{1,3}\.){3}\d{1,3}\]?)|(([-a-zA-Z0-9]+\.)+[a-zA-Z]{2,4}))(\:\d+)?(/[-a-zA-Z0-9._?,'+&%$#=~\\]+)*/?)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "http") (re.opt (str.to_re "s"))) (str.to_re "ftp")) (str.to_re "://") (re.union (re.++ (re.opt (str.to_re "[")) ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re "]"))) (re.++ (re.+ (re.++ (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "."))) ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.* (re.++ (str.to_re "/") (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "?") (str.to_re ",") (str.to_re "'") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~") (str.to_re "\u{5c}"))))) (re.opt (str.to_re "/"))))))
; ^[0-9]{2}
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Points\d+Host\u{3a}\stoBasicwww\x2Ewebcruiser\x2Ecc
(assert (not (str.in_re X (re.++ (str.to_re "Points") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toBasicwww.webcruiser.cc\u{0a}")))))
; ^([a-z0-9]+([\-a-z0-9]*[a-z0-9]+)?\.){0,}([a-z0-9]+([\-a-z0-9]*[a-z0-9]+)?){1,63}(\.[a-z0-9]{2,7})+$
(assert (not (str.in_re X (re.++ (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.opt (re.++ (re.* (re.union (str.to_re "-") (re.range "a" "z") (re.range "0" "9"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re "."))) ((_ re.loop 1 63) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.opt (re.++ (re.* (re.union (str.to_re "-") (re.range "a" "z") (re.range "0" "9"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))))) (re.+ (re.++ (str.to_re ".") ((_ re.loop 2 7) (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
