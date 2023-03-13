(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((https?|ftp)\://((\[?(\d{1,3}\.){3}\d{1,3}\]?)|(([-a-zA-Z0-9]+\.)+[a-zA-Z]{2,4}))(\:\d+)?(/[-a-zA-Z0-9._?,'+&%$#=~\\]+)*/?)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "http") (re.opt (str.to_re "s"))) (str.to_re "ftp")) (str.to_re "://") (re.union (re.++ (re.opt (str.to_re "[")) ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re "]"))) (re.++ (re.+ (re.++ (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "."))) ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.* (re.++ (str.to_re "/") (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "?") (str.to_re ",") (str.to_re "'") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~") (str.to_re "\u{5c}"))))) (re.opt (str.to_re "/")))))
; ((([7-9])(\d{3})([-])(\d{4}))|(([7-9])(\d{7})))
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "7" "9") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "7" "9") ((_ re.loop 7 7) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; (^\d{1,2}\.\d{1,2}\.\d{4})|(^\d{1,2}\.\d{1,2})|(^\d{1,2})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; \u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (str.in_re X (str.to_re "(robert@blackcastlesoft.com)\u{0a}")))
; /[a-zA-Z0-9]\/[a-f0-9]{5}\.swf[\u{22}\u{27}]/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "/") ((_ re.loop 5 5) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".swf") (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "/\u{0a}"))))
(check-sat)
