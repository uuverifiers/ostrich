(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\sHello\x2E.*forum=
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Hello.") (re.* re.allchar) (str.to_re "forum=\u{0a}"))))
; as\x2Estarware\x2Ecom%3fUser-Agent\x3Ahostie
(assert (not (str.in_re X (str.to_re "as.starware.com%3fUser-Agent:hostie\u{0a}"))))
; ((\d{0}[0-9]|\d{0}[1]\d{0}[0-2])(\:)\d{0}[0-5]\d{0}[0-9](\:)\d{0}[0-5]\d{0}[0-9]\s(AM|PM))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ ((_ re.loop 0 0) (re.range "0" "9")) (re.range "0" "9")) (re.++ ((_ re.loop 0 0) (re.range "0" "9")) (str.to_re "1") ((_ re.loop 0 0) (re.range "0" "9")) (re.range "0" "2"))) (str.to_re ":") ((_ re.loop 0 0) (re.range "0" "9")) (re.range "0" "5") ((_ re.loop 0 0) (re.range "0" "9")) (re.range "0" "9") (str.to_re ":") ((_ re.loop 0 0) (re.range "0" "9")) (re.range "0" "5") ((_ re.loop 0 0) (re.range "0" "9")) (re.range "0" "9") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (str.to_re "AM") (str.to_re "PM")))))
; /^[a-z]\u{3d}[a-f\d]{80,140}$/Pi
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 80 140) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Pi\u{0a}"))))
; (((ht|f)tp(s?))\://)?(\bw{3}[^w]\b)?[^w{4}][^\@]([0-9a-zA-Z\-]+\.)+[a-zA-Z]{2,6}(\:[0-9]+)?(/\S*)?
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "://") (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")))) (re.opt (re.++ ((_ re.loop 3 3) (str.to_re "w")) (re.comp (str.to_re "w")))) (re.union (str.to_re "w") (str.to_re "{") (str.to_re "4") (str.to_re "}")) (re.comp (str.to_re "@")) (re.+ (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "-"))) (str.to_re "."))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))) (str.to_re "\u{0a}")))))
(check-sat)
