(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; HXLogOnlyDaemonactivityIterenetFrom\x3AClass
(assert (str.in_re X (str.to_re "HXLogOnlyDaemonactivityIterenetFrom:Class\u{0a}")))
; [a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}
(assert (not (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-4") ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") (re.union (str.to_re "8") (str.to_re "9") (str.to_re "a") (str.to_re "b")) ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; `.*?((http|ftp|https)://[\w#$&+,\/:;=?@.-]+)[^\w#$&+,\/:;=?@.-]*?`i
(assert (not (str.in_re X (re.++ (str.to_re "`") (re.* re.allchar) (re.* (re.union (str.to_re "#") (str.to_re "$") (str.to_re "&") (str.to_re "+") (str.to_re ",") (str.to_re "/") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "?") (str.to_re "@") (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "`i\u{0a}") (re.union (str.to_re "http") (str.to_re "ftp") (str.to_re "https")) (str.to_re "://") (re.+ (re.union (str.to_re "#") (str.to_re "$") (str.to_re "&") (str.to_re "+") (str.to_re ",") (str.to_re "/") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "?") (str.to_re "@") (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
; Ready\s+Eye.*http\x3A\x2F\x2Fsupremetoolbar
(assert (not (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Eye") (re.* re.allchar) (str.to_re "http://supremetoolbar\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
