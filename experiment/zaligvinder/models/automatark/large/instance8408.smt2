(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/\?[a-z0-9]{9}\=[a-zA-Z0-9]{45}/U
(assert (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 9 9) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 45 45) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; http://[^/]*/
(assert (str.in_re X (re.++ (str.to_re "http://") (re.* (re.comp (str.to_re "/"))) (str.to_re "/\u{0a}"))))
; /\r\nHost\u{3a}\u{20}[a-z0-9\u{2d}\u{2e}]+\.com\u{2d}[a-z0-9\u{2d}\u{2e}]+(\u{3a}\d{1,5})?\r\n/Hi
(assert (not (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}Host: ") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".com-") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "\u{0d}\u{0a}/Hi\u{0a}")))))
; encoder\s%3fsearchresltX-Mailer\x3A
(assert (str.in_re X (re.++ (str.to_re "encoder") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "%3fsearchresltX-Mailer:\u{13}\u{0a}"))))
(check-sat)
